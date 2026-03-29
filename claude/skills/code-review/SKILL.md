# Skill: Code Review

## Toolbox Section

This skill provides expertise in analyzing code quality across key dimensions that require human judgment:

- **Logic & Correctness**: Identifies bugs, edge cases, and logical errors
- **Security**: Detects vulnerabilities like injection flaws, unsafe patterns, or insecure dependencies
- **Performance**: Flags inefficient algorithms, memory issues, or optimization opportunities
- **Architecture**: Evaluates component separation, coupling/cohesion, scalability patterns, and design decisions
- **Compliance & Privacy**: Ensures adherence to regulations (GDPR, HIPAA), data handling rules, and legal requirements like not storing unnecessary PII
- **Maintainability**: Reviews readability, modularity, documentation, and code organization
- **Naming Conventions**: Evaluates variable/function/class names for clarity, consistency, and discoverability
- **API Compatibility**: Detects breaking changes in APIs, versioning violations, and backward compatibility issues
- **Type Safety & Design**: Identifies opportunities to use type systems to prevent invalid states, improve correctness through design (e.g., making illegal states unrepresentable), and leverage language features for robustness

## Process Section

When reviewing code:

1. **Analyze the context** - Understand what the code is supposed to do
2. **Scan systematically** - Review each dimension (logic, security, performance, architecture, compliance, maintainability, naming, API compatibility, type safety) independently
3. **Prioritize issues** - Rank findings by severity and impact
4. **Provide actionable feedback** - Suggest specific improvements with examples when helpful

## Constraints Section

- Be constructive and respectful in all feedback
- Explain the "why" behind recommendations
- Consider trade-offs (e.g., readability vs performance, flexibility vs complexity)
- Don't nitpick unless it's a clear best practice violation
- Acknowledge constraints that might make certain fixes impractical
