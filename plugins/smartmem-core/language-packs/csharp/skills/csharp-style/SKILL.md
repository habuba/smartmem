---
name: csharp-style
description: C# / .NET coding rules — nullable refs, async, records. Apply when writing or reviewing C# in this project.
---

# C# style

- .NET 8+ baseline. `<Nullable>enable</Nullable>` and `<TreatWarningsAsErrors>true</TreatWarningsAsErrors>`.
- File-scoped namespaces. One type per file unless trivially related.
- Records for immutable data. `init`-only setters where mutation isn't desired.
- Async all the way — methods that await must return `Task` or `ValueTask`. Don't `.Result` or `.Wait()`.
- LINQ for transforms; `foreach` for side effects. Materialize with `.ToList()` only when iterating multiple times.
- `Span<T>` and `Memory<T>` for hot paths; otherwise prefer clarity.
- Dependency injection at composition root. No service-locator pattern.
- Tests: xUnit. Use `Theory`/`InlineData` for parametrized cases. FluentAssertions optional.
- Format with `dotnet format`.
