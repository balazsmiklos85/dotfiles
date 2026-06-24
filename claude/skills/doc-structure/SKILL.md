---
name: doc-structure
description: "Creates and maintains project documentation following established conventions. Use when writing, updating, or organizing documentation in any project."
---

# Role

Generate and maintain project documentation following the project's established structure and style conventions.

Load the `tech-writer` skill before writing any documentation content.

## Documentation Path

The documentation location is **not fixed**. Determine the correct path for each project by checking:

1. Existing documentation already present in the project
2. Project configuration or conventions (e.g., `docs/`, `documentation/`, `doc/`)
3. If no documentation exists yet, default to `docs/` at the project root

## Documentation Structure

Create documentation using these four categories:

```
<docs-root>/
├── architecture/
│   ├── overview.md
│   └── architecture-decisions/
│       └── .gitkeep
├── code/
│   ├── testing-strategy.md
│   ├── class-interactions.md
│   └── process-workflows.md
├── components/
│   ├── business-logic.md
│   ├── controllers.md
│   ├── database.md
│   ├── routes.md
│   ├── supporting-components.md
│   └── views.md
├── context/
│   ├── dev-setup.md
│   ├── deployment.md
│   └── system-context.md
```

### Category Purposes

| Category | Purpose | Diátaxis Type |
|---|---|---|
| `architecture/` | High-level design, framework decisions, ADRs | Explanation, Reference |
| `code/` | Testing strategy, diagrams, workflows | How-to Guide, Explanation |
| `components/` | Component reference, routes, data layer | Reference |
| `context/` | Setup, deployment, system boundaries | Tutorial, How-to Guide |

## File Templates

### Architecture Overview

```markdown
# Architecture Overview

## Architecture Style

Describe the architectural approach the project follows (e.g., layered, hexagonal, clean architecture).

- **Controllers** handle HTTP requests and response formatting
- **Services** encapsulate business logic
- **Repositories** or data access layers manage persistence
- **Views** or presentation layers handle rendering

## Component Diagrams

```mermaid
graph TD
    A[Client] --> B[API Layer]
    B --> C[Service Layer]
    C --> D[Data Layer]
```
```

### Architecture Decision Record

Number sequentially with leading zeros. Use this template:

```markdown
# <Title>

## Status

Accepted | Proposed | Deprecated | Superseded

## Context

Describe the problem, constraints, and alternatives considered.

## Decision

State the decision clearly.

### Rationale

Explain why this decision was made.

## Consequences

### Positive

List positive outcomes.

### Negative

List negative outcomes and trade-offs.

## References

Link to relevant documentation or resources.
```

### Component Reference

```markdown
# <Component Name>

## Overview

One sentence describing the component's responsibility.

## Reference

### <Item Name>

**<Class or Package>** - `<file path>`
: Brief description of purpose
```

### Context Document

```markdown
# <Title>

## Overview

Brief description of what this document covers.

## Prerequisites

- List required tools or services

## Steps

Numbered steps for sequential actions.

## Configuration

Document configuration options and environment variables.
```

### Code Documentation

```markdown
# <Title>

## Overview

Describe the topic.

### Diagrams

Use Mermaid for visual documentation:

```mermaid
sequenceDiagram
    participant Client
    participant Controller
    participant Service
    participant Repository

    Client->>Controller: Request
    Controller->>Service: Business logic
    Service->>Repository: Query data
    Repository-->>Service: Data returned
    Service-->>Controller: Result
    Controller-->>Client: Response
```
```

## Writing Process

1. Identify which category the documentation belongs to
2. Determine the project's documentation root path
3. Check if the file already exists
4. Load the `tech-writer` skill for style conventions
5. Verify facts against the codebase
6. Write content using the appropriate template
7. Include Mermaid diagrams where they clarify complex relationships
8. Cross-reference related documents with descriptive links

## Style Rules

Apply these conventions to all documentation:

- Use concise, clear language
- Prefer active voice and imperative verbs
- Avoid contractions
- Use the Oxford comma
- Avoid parentheses
- Start procedural sections with what and why
- Use numbered lists for sequential steps
- Use bulleted lists for grouped items
- Use bold for UI elements and file paths
- Use tables for comparable data
- Write descriptive links instead of click here

## When to Create New Files

Create a new documentation file when:

- Adding a new component requires a reference document
- An architecture decision needs formal recording
- A new process or workflow needs explanation
- Setup or deployment instructions need updating
- Code patterns require clarification

## When to Update Existing Files

Update existing documentation when:

- Component behavior changes
- Configuration options are added or removed
- Architecture decisions evolve
- Testing strategies change
- Setup steps are modified
