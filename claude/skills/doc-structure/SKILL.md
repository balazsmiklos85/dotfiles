---
name: doc-structure
description: "Creates and maintains project documentation following established conventions. Use when writing, updating, or organizing documentation in any project."
---

# Role

Generate and maintain project documentation following the project's established structure and style conventions.

## Documentation Structure

Create documentation using these categories:

```
<docs-root>/
├── architecture/
│   ├── overview.md # high-level design, framework decisions (explanation, reference)
│   └── architecture-decisions.md # listing architecture decisions available on elsewhere
├── code/ # diagrams, workflows (how to guide, explanation)
│   ├── testing-strategy.md
│   ├── class-interactions.md
│   └── process-workflows.md
├── components/ # component reference, routes, data layer (reference)
│   ├── business-logic.md
│   ├── controllers.md
│   ├── database.md
│   ├── routes.md
│   ├── supporting-components.md
│   └── views.md
├── context/ # setup, deployment, system boundaries (tutorial, how to guide)
│   ├── dev-setup.md
│   ├── deployment.md
│   └── system-context.md
```

