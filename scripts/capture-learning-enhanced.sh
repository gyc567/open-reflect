#!/bin/bash
# Open-Reflect V1: Enhanced Learning Capture System
# Features: multi-dimensional capture, semantic analysis, confidence scoring
# Used by UserPromptSubmit hook

QUEUE_FILE="$HOME/.claude/openreflect-queue.json"
REFLECT_FILE="$PWD/REFLECT.md"

# Read JSON from stdin
INPUT="$(cat -)"
[ -z "$INPUT" ] && exit 0

# Extract prompt from JSON
PROMPT="$(echo "$INPUT" | jq -r '.prompt // .message // .text // empty' 2>/dev/null)"
[ -z "$PROMPT" ] && exit 0

# Get current project path
PROJECT="$(pwd)"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Initialize queue if doesn't exist
[ ! -f "$QUEUE_FILE" ] && echo "[]" > "$QUEUE_FILE"

# Learning dimensions
TYPE=""
CATEGORY=""
CONFIDENCE=0.0
SUBCATEGORY=""
MATCHED_PATTERNS=""
PRIORITY="normal"
TAGS=[]
DECAY_DAYS=90

# Enhanced pattern detection with multi-dimensional classification

# Explicit "remember:" - HIGHEST priority
if echo "$PROMPT" | grep -qiE "^remember:|^remember\b"; then
  TYPE="explicit"
  CATEGORY="preference"
  CONFIDENCE=0.95
  DECAY_DAYS=180
  PRIORITY="critical"
  TAGS='["explicit", "critical"]'

# POSITIVE patterns - capture what works
elif echo "$PROMPT" | grep -qiE "perfect!|exactly right|that's exactly|that's what I wanted|great approach|keep doing this|love it|excellent|nailed it|brilliant|awesome|spot on"; then
  TYPE="positive"
  CATEGORY="success_pattern"
  CONFIDENCE=0.75
  DECAY_DAYS=120

  if echo "$PROMPT" | grep -qiE "perfect!|exactly right|that's exactly"; then
    SUBCATEGORY="perfect_match"
    MATCHED_PATTERNS="$MATCHED_PATTERNS perfect"
  elif echo "$PROMPT" | grep -qiE "that's what I wanted|great approach"; then
    SUBCATEGORY="great_approach"
    MATCHED_PATTERNS="$MATCHED_PATTERNS great-approach"
  else
    SUBCATEGORY="positive_feedback"
    MATCHED_PATTERNS="$MATCHED_PATTERNS positive"
  fi
  TAGS='["success", "verified"]'

# CORRECTION patterns - enhanced with subcategories
else
  # Strong corrections (high confidence)
  if echo "$PROMPT" | grep -qiE "no[,. ]+use"; then
    TYPE="correction"
    CATEGORY="correction"
    SUBCATEGORY="explicit_correction"
    CONFIDENCE=0.90
    MATCHED_PATTERNS="$MATCHED_PATTERNS no,use"
  fi

  if echo "$PROMPT" | grep -qiE "don't use|do not use"; then
    TYPE="correction"
    CATEGORY="correction"
    SUBCATEGORY="negative_correction"
    CONFIDENCE=0.90
    MATCHED_PATTERNS="$MATCHED_PATTERNS don't-use"
  fi

  if echo "$PROMPT" | grep -qiE "stop using|never use"; then
    TYPE="correction"
    CATEGORY="correction"
    SUBCATEGORY="prohibition"
    CONFIDENCE=0.90
    MATCHED_PATTERNS="$MATCHED_PATTERNS stop/never-use"
  fi

  if echo "$PROMPT" | grep -qiE "that's (wrong|incorrect)|that is (wrong|incorrect)"; then
    TYPE="correction"
    CATEGORY="correction"
    SUBCATEGORY="error_correction"
    CONFIDENCE=0.85
    MATCHED_PATTERNS="$MATCHED_PATTERNS that's-wrong"
  fi

  # Medium corrections
  if echo "$PROMPT" | grep -qiE "not right|not correct"; then
    TYPE="correction"
    CATEGORY="correction"
    SUBCATEGORY="gentle_correction"
    CONFIDENCE=0.70
    MATCHED_PATTERNS="$MATCHED_PATTERNS not-right"
  fi

  if echo "$PROMPT" | grep -qiE "^actually[,. ]|[.!?] actually[,. ]"; then
    TYPE="correction"
    CATEGORY="correction"
    SUBCATEGORY="refinement"
    CONFIDENCE=0.65
    MATCHED_PATTERNS="$MATCHED_PATTERNS actually"
  fi

  if echo "$PROMPT" | grep -qiE "I meant|I said"; then
    TYPE="correction"
    CATEGORY="correction"
    SUBCATEGORY="clarification"
    CONFIDENCE=0.80
    MATCHED_PATTERNS="$MATCHED_PATTERNS I-meant/said"
  fi

  if echo "$PROMPT" | grep -qiE "I told you|I already told"; then
    TYPE="correction"
    CATEGORY="correction"
    SUBCATEGORY="repeated_correction"
    CONFIDENCE=0.92
    PRIORITY="high"
    DECAY_DAYS=150
    TAGS='["repeated", "important"]'
    MATCHED_PATTERNS="$MATCHED_PATTERNS I-told-you"
  fi

  if echo "$PROMPT" | grep -qiE "you (should|need to|must) use"; then
    TYPE="correction"
    CATEGORY="preference"
    SUBCATEGORY="suggestion"
    CONFIDENCE=0.70
    MATCHED_PATTERNS="$MATCHED_PATTERNS you-should-use"
  fi

  if echo "$PROMPT" | grep -qiE "use .+ not|not .+, use"; then
    TYPE="correction"
    CATEGORY="correction"
    SUBCATEGORY="comparison_correction"
    CONFIDENCE=0.85
    MATCHED_PATTERNS="$MATCHED_PATTERNS use-X-not-Y"
  fi

  # Apply correction defaults if any matched
  if [ -n "$TYPE" ] && [ "$TYPE" = "correction" ] && [ -z "$TAGS" ]; then
    TAGS='["correction", "pending-review"]'
  fi
fi

# Smart priority adjustment based on pattern strength
if [ -n "$TYPE" ]; then
  if [ "$CONFIDENCE" -ge 0.90 ]; then
    PRIORITY="critical"
  elif [ "$CONFIDENCE" -ge 0.80 ]; then
    PRIORITY="high"
  elif [ "$CONFIDENCE" -ge 0.70 ]; then
    PRIORITY="medium"
  fi

  # Trim leading space from matched patterns
  MATCHED_PATTERNS=$(echo "$MATCHED_PATTERNS" | sed 's/^ *//')

  # Enhanced queue item with multi-dimensional metadata
  jq --arg type "$TYPE" \
     --arg category "$CATEGORY" \
     --arg subcategory "$SUBCATEGORY" \
     --arg msg "$PROMPT" \
     --arg ts "$TIMESTAMP" \
     --arg proj "$PROJECT" \
     --arg patterns "$MATCHED_PATTERNS" \
     --arg confidence "$CONFIDENCE" \
     --arg priority "$PRIORITY" \
     --arg tags "$TAGS" \
     --arg decay "$DECAY_DAYS" \
     '. += [{
       "type": $type,
       "category": $category,
       "subcategory": $subcategory | if . == "" then null else . end,
       "message": $msg,
       "timestamp": $ts,
       "project": $proj,
       "patterns": $patterns,
       "confidence": ($confidence | tonumber),
       "priority": $priority,
       "tags": ($tags | fromjson),
       "decay_days": ($decay | tonumber),
       "status": "pending",
       "evolution_count": 0,
       "usage_count": 0,
       "last_validated": null
     }]' \
     "$QUEUE_FILE" > "$QUEUE_FILE.tmp" 2>/dev/null && mv "$QUEUE_FILE.tmp" "$QUEUE_FILE"
fi

exit 0
