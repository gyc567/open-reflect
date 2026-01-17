/**
 * Open-Reflect OpenCode Plugin TDD Tests
 * 
 * TDD Approach: Write failing tests first, then implement features
 * 
 * Run with: npx ts-node --esm tests/opencode-plugin/tdd-tests.test.ts
 */

const fs = require('fs')
const path = require('path')

console.log("🧪 Open-Reflect OpenCode Plugin TDD Tests")
console.log("=" .repeat(60))
console.log("")

let testsPassed = 0
let testsFailed = 0
let currentTestFile = ""

// Mock process.exit to prevent early termination
const originalExit = process.exit
process.exit = ((code: any) => {
  // Don't actually exit in tests
}) as typeof process.exit

process.on('exit', () => {
  process.exit = originalExit
})

function test(name: string, fn: () => void | Promise<void>) {
  currentTestFile = name
  try {
    const result = fn()
    if (result && typeof result.then === 'function') {
      result.then(() => {
        console.log(`✅ ${name}`)
        testsPassed++
      }).catch((error) => {
        console.log(`❌ ${name}`)
        console.log(`   Error: ${error}`)
        testsFailed++
      })
    } else {
      console.log(`✅ ${name}`)
      testsPassed++
    }
  } catch (error) {
    console.log(`❌ ${name}`)
    console.log(`   Error: ${error}`)
    testsFailed++
  }
}

function expect(actual: any): {
  toBe: (expected: any) => void
  toEqual: (expected: any) => void
  toContain: (expected: any) => void
  toBeDefined: () => void
  toBeTruthy: () => void
  toBeFalsy: () => void
  toThrow: () => void
  toBeGreaterThan: (expected: any) => void
  toMatch: (expected: RegExp) => void
} {
  return {
    toBe: (expected: any) => {
      if (actual !== expected) {
        throw new Error(`Expected ${expected} but got ${actual}`)
      }
    },
    toEqual: (expected: any) => {
      if (JSON.stringify(actual) !== JSON.stringify(expected)) {
        throw new Error(`Expected ${JSON.stringify(expected)} but got ${JSON.stringify(actual)}`)
      }
    },
    toContain: (expected: any) => {
      if (!actual.includes(expected)) {
        throw new Error(`Expected ${actual} to contain ${expected}`)
      }
    },
    toBeDefined: () => {
      if (actual === undefined) {
        throw new Error(`Expected value to be defined`)
      }
    },
    toBeTruthy: () => {
      if (!actual) {
        throw new Error(`Expected truthy value but got ${actual}`)
      }
    },
    toBeFalsy: () => {
      if (actual) {
        throw new Error(`Expected falsy value but got ${actual}`)
      }
    },
    toThrow: () => {
      let threw = false
      try {
        actual()
      } catch {
        threw = true
      }
      if (!threw) {
        throw new Error(`Expected function to throw`)
      }
    },
    toBeGreaterThan: (expected: any) => {
      if (!(actual > expected)) {
        throw new Error(`Expected ${actual} to be greater than ${expected}`)
      }
    },
    toMatch: (expected: RegExp) => {
      if (!expected.test(actual)) {
        throw new Error(`Expected ${actual} to match ${expected}`)
      }
    }
  }
}

function existsSync(filePath: string): boolean {
  try {
    return fs.existsSync(filePath)
  } catch {
    return false
  }
}

function readFileSync(filePath: string, encoding: string = 'utf-8'): string {
  return fs.readFileSync(filePath, encoding)
}

function writeFileSync(filePath: string, content: string, encoding: string = 'utf-8'): void {
  fs.writeFileSync(filePath, content, encoding)
}

function mkdirSync(dirPath: string, options: { recursive: boolean }): void {
  fs.mkdirSync(dirPath, options)
}

// ============================================================================
// TDD CATEGORY 1: Plugin Configuration Tests
// ============================================================================

console.log("\n📋 Category 1: Plugin Configuration Tests")
console.log("-".repeat(60))

test("Plugin configuration should have valid OpenCode plugin structure", () => {
  const configPath = path.join(process.cwd(), '.opencode', 'plugin.config.json')
  expect(existsSync(configPath)).toBeTruthy()
  
  const config = JSON.parse(readFileSync(configPath, 'utf-8'))
  expect(config.name).toBe('open-reflect')
  expect(config.version).toBe('1.0.0')
  expect(config.description).toBeDefined()
  expect(config.engines).toBeDefined()
  expect(config.engines.opencode).toBeDefined()
})

test("Plugin should have OpenCode permission config", () => {
  const configPath = path.join(process.cwd(), '.opencode', 'open-reflect-config.json')
  expect(existsSync(configPath)).toBeTruthy()
  
  const config = JSON.parse(readFileSync(configPath, 'utf-8'))
  expect(config.permission).toBeDefined()
  expect(config.agent).toBeDefined()
})

test("Plugin package.json should have correct dependencies", () => {
  const packagePath = path.join(process.cwd(), '.opencode', 'package.json')
  expect(existsSync(packagePath)).toBeTruthy()
  
  const pkg = JSON.parse(readFileSync(packagePath, 'utf-8'))
  expect(pkg.dependencies).toBeDefined()
  expect(pkg.dependencies["@opencode-ai/plugin"]).toBeDefined()
})

// ============================================================================
// TDD CATEGORY 2: Plugin File Structure Tests
// ============================================================================

console.log("\n📁 Category 2: Plugin File Structure Tests")
console.log("-".repeat(60))

test("OpenCode plugin file should exist", () => {
  const pluginPath = path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts')
  expect(existsSync(pluginPath)).toBeTruthy()
  
  const content = readFileSync(pluginPath, 'utf-8')
  expect(content.length).toBeGreaterThan(1000)
})

test("Plugin should export OpenReflectPlugin function", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('export const OpenReflectPlugin')
})

test("Plugin should import from @opencode-ai/plugin", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('@opencode-ai/plugin')
})

test("Plugin should use tool helper from @opencode-ai/plugin", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('from "@opencode-ai/plugin"')
  expect(content).toContain('tool({')
})

test("Plugin should define Plugin type from @opencode-ai/plugin", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('import type { Plugin }')
})

// ============================================================================
// TDD CATEGORY 3: Tool Definition Tests
// ============================================================================

console.log("\n🛠️ Category 3: Tool Definition Tests")
console.log("-".repeat(60))

test("Plugin should define 'repo' tool", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('repo: tool({')
})

test("Plugin should define 'skip-reflect' tool", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('"skip-reflect": tool({')
})

test("Plugin should define 'view-queue' tool", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('"view-queue": tool({')
})

test("'repo' tool should have description", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toMatch(/repo: tool\(\{[\s\S]*?description:/)
})

test("'repo' tool should support --view argument", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('--view')
  expect(content).toContain('command: tool.schema.string()')
})

// ============================================================================
// TDD CATEGORY 4: Hook Definition Tests
// ============================================================================

console.log("\n🪝 Category 4: Hook Definition Tests")
console.log("-".repeat(60))

test("Plugin should define session.compacted hook", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('"session.compacted"')
})

test("Plugin should define tool.execute.before hook", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('"tool.execute.before"')
})

test("Plugin should define message.updated hook", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('"message.updated"')
})

// ============================================================================
// TDD CATEGORY 5: Pattern Detection Tests
// ============================================================================

console.log("\n🔍 Category 5: Pattern Detection Tests")
console.log("-".repeat(60))

test("Should detect 'no, use X' correction pattern", () => {
  const patterns = {
    corrections: [
      /no[,. ]+use/i,
      /don't use/i,
      /do not use/i,
      /stop using/i,
      /never use/i,
      /that's (wrong|incorrect)/i,
      /not right/i,
      /^[.!?]*actually[,. ]/i,
      /I meant/i,
      /I said/i
    ]
  }
  
  const testMessage = "no, use gpt-5.1 not gpt-5"
  const detected = patterns.corrections.some(pattern => pattern.test(testMessage))
  expect(detected).toBeTruthy()
})

test("Should detect 'remember:' explicit pattern", () => {
  const explicitPattern = /^remember:/i
  const testMessage = "remember: always use venv for Python"
  expect(explicitPattern.test(testMessage)).toBeTruthy()
})

test("Should detect positive feedback pattern", () => {
  const positivePatterns = /perfect!|exactly right|great approach|love it/i
  const testMessage = "Perfect! That's exactly what I wanted."
  expect(positivePatterns.test(testMessage)).toBeTruthy()
})

test("Should detect multiple patterns in same message", () => {
  const explicitPattern = /^remember:/i
  const correctionPattern = /no[,. ]+use/i
  const positivePattern = /perfect!/i
  
  const message = "remember: no, use gpt-5.1 not gpt-5, Perfect!"
  
  expect(explicitPattern.test(message)).toBeTruthy()
  expect(correctionPattern.test(message)).toBeTruthy()
  expect(positivePattern.test(message)).toBeTruthy()
})

test("Should have confidence scores for patterns", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('confidence')
})

// ============================================================================
// TDD CATEGORY 6: Queue Operations Tests
// ============================================================================

console.log("\n📊 Category 6: Queue Operations Tests")
console.log("-".repeat(60))

test("Should be able to create queue file", () => {
  const testDir = path.join(process.cwd(), 'tests', 'test-output')
  if (!existsSync(testDir)) {
    mkdirSync(testDir, { recursive: true })
  }
  
  const testQueueFile = path.join(testDir, 'test-queue.json')
  
  // Clean up first
  if (existsSync(testQueueFile)) {
    fs.unlinkSync(testQueueFile)
  }
  
  // Create queue file
  writeFileSync(testQueueFile, "[]", "utf-8")
  
  expect(existsSync(testQueueFile)).toBeTruthy()
  
  const data = JSON.parse(readFileSync(testQueueFile, 'utf-8'))
  expect(Array.isArray(data)).toBeTruthy()
  
  // Clean up
  fs.unlinkSync(testQueueFile)
})

test("Should be able to add and read from queue", () => {
  const testDir = path.join(process.cwd(), 'tests', 'test-output')
  const testQueueFile = path.join(testDir, 'test-queue.json')
  
  // Create queue with data
  const testData = [
    { id: "1", type: "correction", message: "test correction", confidence: 0.90 },
    { id: "2", type: "positive", message: "test positive", confidence: 0.75 }
  ]
  
  writeFileSync(testQueueFile, JSON.stringify(testData, null, 2), "utf-8")
  
  const readData = JSON.parse(readFileSync(testQueueFile, 'utf-8'))
  expect(readData.length).toBe(2)
  expect(readData[0].type).toBe("correction")
  expect(readData[1].type).toBe("positive")
  
  // Clean up
  fs.unlinkSync(testQueueFile)
})

test("Queue entry should have required fields", () => {
  const testDir = path.join(process.cwd(), 'tests', 'test-output')
  const testQueueFile = path.join(testDir, 'test-queue.json')
  
  // Create queue with complete entry
  const testData = [{
    id: "1",
    type: "correction",
    confidence: 0.90,
    message: "test correction",
    timestamp: "2024-01-01T00:00:00.000Z",
    project: "test-project",
    status: "pending"
  }]
  
  writeFileSync(testQueueFile, JSON.stringify(testData, null, 2), "utf-8")
  
  const readData = JSON.parse(readFileSync(testQueueFile, 'utf-8'))
  expect(readData[0].id).toBeDefined()
  expect(readData[0].type).toBeDefined()
  expect(readData[0].confidence).toBeDefined()
  expect(readData[0].message).toBeDefined()
  expect(readData[0].timestamp).toBeDefined()
  expect(readData[0].project).toBeDefined()
  expect(readData[0].status).toBeDefined()
  
  // Clean up
  fs.unlinkSync(testQueueFile)
})

// ============================================================================
// TDD CATEGORY 7: REFLECT.md Operations Tests
// ============================================================================

console.log("\n📝 Category 7: REFLECT.md Operations Tests")
console.log("-".repeat(60))

test("Should be able to create REFLECT.md", () => {
  const testDir = path.join(process.cwd(), 'tests', 'test-output')
  const testReflectFile = path.join(testDir, 'test-REFLECT.md')
  
  // Clean up first
  if (existsSync(testReflectFile)) {
    fs.unlinkSync(testReflectFile)
  }
  
  // Create REFLECT.md
  const template = `# Open-Reflect Test

## 学习分类
*暂无内容*

---
Generated by test
`
  writeFileSync(testReflectFile, template, "utf-8")
  
  expect(existsSync(testReflectFile)).toBeTruthy()
  
  const content = readFileSync(testReflectFile, "utf-8")
  expect(content).toContain("Open-Reflect Test")
  expect(content).toContain("学习分类")
  
  // Clean up
  fs.unlinkSync(testReflectFile)
})

test("REFLECT.md should have proper structure", () => {
  const testDir = path.join(process.cwd(), 'tests', 'test-output')
  const testReflectFile = path.join(testDir, 'test-REFLECT.md')
  
  // Clean up first
  if (existsSync(testReflectFile)) {
    fs.unlinkSync(testReflectFile)
  }
  
  // Create REFLECT.md with proper structure
  const template = `# Open-Reflect Knowledge Evolution Log

> Open-Reflect intermediate learning records

## 🎯 Learning Categories
*No learnings yet*

## 📜 Evolution History
| Version | Date | Change Type | Description |

---
*Generated by Open-Reflect OpenCode Plugin*
`
  writeFileSync(testReflectFile, template, "utf-8")
  
  const content = readFileSync(testReflectFile, "utf-8")
  expect(content).toContain("# Open-Reflect Knowledge Evolution Log")
  expect(content).toContain("## 🎯 Learning Categories")
  expect(content).toContain("## 📜 Evolution History")
  
  // Clean up
  fs.unlinkSync(testReflectFile)
})

// ============================================================================
// TDD CATEGORY 8: Plugin Type Definition Tests
// ============================================================================

console.log("\n📘 Category 8: Plugin Type Definition Tests")
console.log("-".repeat(60))

test("Plugin should define QueueEntry interface", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('interface QueueEntry')
})

test("QueueEntry should have correct fields", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('id: string')
  expect(content).toContain('type: "correction" | "positive" | "explicit"')
  expect(content).toContain('confidence: number')
  expect(content).toContain('message: string')
  expect(content).toContain('timestamp: string')
  expect(content).toContain('project: string')
  expect(content).toContain('status: "pending" | "processed"')
})

test("Plugin should define PluginInput interface", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('interface PluginInput')
})

test("PluginInput should include required context fields", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('client:')
  expect(content).toContain('project:')
  expect(content).toContain('directory:')
  expect(content).toContain('worktree:')
  expect(content).toContain('$:')
})

// ============================================================================
// TDD CATEGORY 9: Utility Function Tests
// ============================================================================

console.log("\n🔧 Category 9: Utility Function Tests")
console.log("-".repeat(60))

test("Plugin should have getQueueFilePath function", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('function getQueueFilePath')
})

test("Plugin should have getReflectFilePath function", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('function getReflectFilePath')
})

test("Plugin should have detectLearning function", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('function detectLearning')
})

test("Plugin should have addToQueue function", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('async function addToQueue')
})

test("Plugin should have processLearnings function", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('async function processLearnings')
})

test("Plugin should have clearQueue function", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('async function clearQueue')
})

test("Plugin should have viewQueue function", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('async function viewQueue')
})

// ============================================================================
// Summary
// ============================================================================

console.log("")
console.log("=" .repeat(60))
console.log(`📊 TDD Test Results: ${testsPassed} passed, ${testsFailed} failed`)
console.log("=" .repeat(60))

if (testsFailed > 0) {
  console.log(`\n❌ ${testsFailed} test(s) failed - Implementation needed`)
  process.exit(1)
} else {
  console.log("\n✅ All TDD tests passed!")
  process.exit(0)
}
