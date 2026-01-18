#!/usr/bin/env python3
"""
Open-Reflect: Scan History for Missed Learnings
Scans past sessions to find corrections, patterns, and preferences
"""

import json
import sys
import os
from pathlib import Path

# Configuration
HISTORY_FILE = os.path.expanduser("~/.claude/history.jsonl")
QUEUE_FILE = os.path.expanduser("~/.claude/openreflect-queue.json")

# ANSI colors
RED = "\033[0;31m"
GREEN = "\033[0;32m"
YELLOW = "\033[1;33m"
BLUE = "\033[0;34m"
NC = "\033[0m"


def print_color(color, text):
    print(f"{color}{text}{NC}")


def main():
    print_color(BLUE, "🔍 Open-Reflect History Scanner")
    print("==============================================")
    print()

    # Check if history file exists
    if not os.path.exists(HISTORY_FILE):
        print_color(YELLOW, f"⚠️  No history file found at {HISTORY_FILE}")
        print("   This is expected if this is a fresh installation.")
        return

    # Check file size
    file_size = os.path.getsize(HISTORY_FILE)
    if file_size < 100:
        print_color(YELLOW, f"⚠️  History file is too small ({file_size} bytes)")
        print("   Not enough data to scan.")
        return

    print(f"📂 Scanning: {HISTORY_FILE}")
    print(f"📐 File size: {file_size} bytes")
    print()

    # Load existing queue for deduplication
    existing_messages = set()
    if os.path.exists(QUEUE_FILE) and os.path.getsize(QUEUE_FILE) > 0:
        try:
            with open(QUEUE_FILE, "r") as f:
                queue = json.load(f)
                for item in queue:
                    msg = item.get("message", "").lower()
                    if msg:
                        existing_messages.add(msg)
        except (json.JSONDecodeError, IOError):
            pass

    # Pattern definitions
    correction_patterns = [
        "no, use",
        "don't use",
        "not y",
        "actually,",
        "instead of",
        "you should have",
        "wrong,",
        "incorrect",
    ]

    success_patterns = [
        "perfect!",
        "exactly what i wanted",
        "great!",
        "exactly right",
        "nailed it",
        "this is perfect",
    ]

    preference_patterns = [
        "i prefer",
        "you should use",
        "i always",
        "in my code",
        "for me,",
    ]

    explicit_patterns = [
        "remember:",
        "note this",
        "important:",
        "make sure to",
        "don't forget",
    ]

    # Counters
    correction_count = 0
    success_count = 0
    preference_count = 0
    explicit_count = 0

    potential_learnings = []

    print("📊 Scanning for learning patterns...")
    print()

    # Process history file
    total_lines = 0
    scanned_lines = 0

    try:
        with open(HISTORY_FILE, "r") as f:
            lines = f.readlines()

        total_lines = len(lines)
        # Process last 5000 lines for performance
        scan_lines = lines[-5000:] if len(lines) > 5000 else lines

        print(f"📝 Processing last {len(scan_lines)} of {total_lines} lines...")

        for line in scan_lines:
            try:
                entry = json.loads(line)
                display = entry.get("display", "")
            except (json.JSONDecodeError, AttributeError):
                continue

            if not display:
                continue

            # Skip certain patterns
            if display.startswith("[Image"):
                continue
            if "Command Line Tools" in display:
                continue

            display_lower = display.lower()

            # Check for duplicates
            is_duplicate = False
            for existing in existing_messages:
                if existing in display_lower or display_lower in existing:
                    is_duplicate = True
                    break
            if is_duplicate:
                continue

            scanned_lines += 1

            # Check patterns
            for pattern in correction_patterns:
                if pattern in display_lower:
                    correction_count += 1
                    if len(potential_learnings) < 15:
                        potential_learnings.append(
                            (
                                "correction",
                                display[:80] + "..." if len(display) > 80 else display,
                            )
                        )
                    break

            for pattern in success_patterns:
                if pattern in display_lower:
                    success_count += 1
                    if len(potential_learnings) < 15:
                        potential_learnings.append(
                            (
                                "success",
                                display[:80] + "..." if len(display) > 80 else display,
                            )
                        )
                    break

            for pattern in preference_patterns:
                if pattern in display_lower:
                    preference_count += 1
                    if len(potential_learnings) < 15:
                        potential_learnings.append(
                            (
                                "preference",
                                display[:80] + "..." if len(display) > 80 else display,
                            )
                        )
                    break

            for pattern in explicit_patterns:
                if pattern in display_lower:
                    explicit_count += 1
                    if len(potential_learnings) < 15:
                        potential_learnings.append(
                            (
                                "explicit",
                                display[:80] + "..." if len(display) > 80 else display,
                            )
                        )
                    break

    except (IOError, json.JSONDecodeError) as e:
        print(f"Error reading history file: {e}")
        return

    print()
    print("════════════════════════════════════════════════════")
    print()

    print_color(BLUE, "📈 Pattern Summary (Last 5000 entries):")
    print()
    print(f"  {RED}Corrections:{NC}   {correction_count}")
    print(f"  {GREEN}Success:{NC}      {success_count}")
    print(f"  {YELLOW}Preferences:{NC}  {preference_count}")
    print(f"  {BLUE}Explicit:{NC}     {explicit_count}")
    print()

    total_potential = (
        correction_count + success_count + preference_count + explicit_count
    )

    if total_potential > 0:
        print_color(BLUE, "🎯 Potential Missed Learnings:")
        print()

        # Group by type
        shown = {"explicit": 0, "correction": 0, "success": 0, "preference": 0}
        limits = {"explicit": 3, "correction": 3, "success": 3, "preference": 3}

        for learning_type, content in potential_learnings:
            if shown[learning_type] < limits[learning_type]:
                color = {
                    "explicit": BLUE,
                    "correction": RED,
                    "success": GREEN,
                    "preference": YELLOW,
                }[learning_type]
                print(f"  {color}[{learning_type.upper()}]{NC} {content}")
                shown[learning_type] += 1

        print()
        print(f"💡 Total potential learnings found: {total_potential}")
        print()
        print("📋 Recommendations:")
        print(
            "   1. Review the corrections above - they may indicate areas for improvement"
        )
        print("   2. Capture explicit learnings with: remember: <learning>")
        print("   3. Run /reflect to process any pending learnings")
    else:
        print_color(GREEN, "✅ No obvious learning patterns detected in recent history")

    print()
    print("════════════════════════════════════════════════════")
    print()
    print("📚 Session Statistics:")
    print(f"   Total sessions in history: {total_lines}")
    queue_count = len(existing_messages) if existing_messages else 0
    print(f"   Queue items pending: {queue_count}")

    if total_potential > 5:
        print()
        print_color(YELLOW, "⚠️  High number of potential learnings detected")
        print("   Consider running /reflect to capture and process them.")
    elif correction_count > 3:
        print()
        print_color(RED, "📉 High correction rate detected")
        print("   Review these patterns to reduce future corrections.")

    print()
    print("✨ Scan complete")


if __name__ == "__main__":
    main()
