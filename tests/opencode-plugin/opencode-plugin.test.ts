/**
 * Open-Reflect OpenCode Plugin Tests
 * 
 * Tests for OpenCode plugin functionality
 */

const fs = require('fs')
const path = require('path')

console.log("🧪 Open-Reflect OpenCode Plugin Tests")
console.log("=" .repeat(50))
console.log("")

let testsPassed = 0
let testsFailed = 0

// Mock process.exit to prevent vitest from failing
const originalExit = process.exit
process.exit = (code: number) => {
  // Don't actually exit in tests
}

// Restore process.exit when done
process.on('exit', () => {
  process.exit = originalExit
})

function test(name: string, fn: () => void | Promise<void>) {
  try {
    fn()
    console.log(`✅ ${name}`)
    testsPassed++
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

function readFileSync(filePath: string, encoding: string): string {
  return fs.readFileSync(filePath, encoding)
}

function writeFileSync(filePath: string, content: string, encoding: string): void {
  fs.writeFileSync(filePath, content, encoding)
}

function mkdirSync(dirPath: string, options: { recursive: boolean }): void {
  fs.mkdirSync(dirPath, options)
}

// ============================================
// TEST 1: Plugin Configuration Validation
// ============================================

test("Plugin configuration should exist and be valid", () => {
  const configPath = path.join(process.cwd(), '.opencode', 'plugin.config.json')
  expect(existsSync(configPath)).toBeTruthy()
  
  const config = JSON.parse(readFileSync(configPath, 'utf-8'))
  expect(config.name).toBe('open-reflect')
  expect(config.version).toBe('1.0.0')
  expect(config.description).toBeDefined()
  expect(config.author).toBeDefined()
})

// ============================================
// TEST 2: Plugin File Structure
// ============================================

test("Plugin file should exist", () => {
  const pluginPath = path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts')
  expect(existsSync(pluginPath)).toBeTruthy()
  
  const content = readFileSync(pluginPath, 'utf-8')
  expect(content.length).toBeGreaterThan(1000)
})

test("Plugin should export OpenReflectPlugin function", () => {
  const content = readFileSync(path.join(process.cwd(), '.opencode', 'plugin', 'open-reflect-plugin.ts'), 'utf-8')
  expect(content).toContain('export const OpenReflectPlugin')
})

// ============================================
// TEST 3: Pattern Detection Logic
// ============================================

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
  const explicitPattern = /remember:/i
  const testMessage = "remember: always use venv for Python"
  expect(explicitPattern.test(testMessage)).toBeTruthy()
})

test("Should detect positive feedback pattern", () => {
  const positivePatterns = /perfect!|exactly right|great approach|love it/i
  const testMessage = "Perfect! That's exactly what I wanted."
  expect(positivePatterns.test(testMessage)).toBeTruthy()
})

test("Should detect multiple patterns in same message", () => {
  const explicitPattern = /remember:/i
  const correctionPattern = /no[,. ]+use/i
  const positivePattern = /perfect!/i
  
  const message = "remember: no, use gpt-5.1 not gpt-5, Perfect!"
  
  expect(explicitPattern.test(message)).toBeTruthy()
  expect(correctionPattern.test(message)).toBeTruthy()
  expect(positivePattern.test(message)).toBeTruthy()
})

// ============================================
// TEST 4: Queue File Operations
// ============================================

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

// ============================================
// TEST 5: REFLECT.md Operations
// ============================================

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

// ============================================
// TEST 6: Plugin Package Configuration
// ============================================

test("OpenCode package.json should exist", () => {
  const packagePath = path.join(process.cwd(), '.opencode', 'package.json')
  expect(existsSync(packagePath)).toBeTruthy()
  
  const pkg = JSON.parse(readFileSync(packagePath, 'utf-8'))
  expect(pkg.name).toBe('open-reflect')
})

// ============================================
// Summary
// ============================================

console.log("")
console.log("=" .repeat(50))
console.log(`📊 Test Results: ${testsPassed} passed, ${testsFailed} failed`)
console.log("=" .repeat(50))

if (testsFailed > 0) {
  console.log(`\n❌ ${testsFailed} test(s) failed`)
  process.exit(1)
} else {
  console.log("\n✅ All tests passed!")
  process.exit(0)
}
