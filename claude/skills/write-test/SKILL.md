---
name: write-test
description: "Use this skill to write and update unit or integration tests"
---

## Toolbox

- Read the class under test!
- Read the dependencies of the class under test!
- Ask the user questions, strictly one-by-one, if something is not clear!

## Process

### To write a new test

1. Understand the functionality to be tested! Look at existing test patterns in the codebase to know how specific things are supposed to be tested!
2. Consider what the interface promises!
    - What is always/never true about the inputs of the unit under test?
    - What is alway/never true about the outputs of the unit under test?
    - What are the edge cases?
    - Which of these statements is useful to be turned into a test? For example, it is useful to test that an input can
      never be bigger than 1000. It is not useful to test that an input can be only of a certain class, type safety
      should be enforced in other ways.
3. Write the tests!

### To update tests

1. Check what changed recenly, either on the current branch, or since we branched off from the main branch!
2. Ask the user what is his problem with the current state of the test, if not clarified already!
3. Construct a strategy to improve the test! Keep it interactive, agree with the user about it!
4. Update the tests!

## Contraints

- Business logic should be tested on the unit test level!
- Integration with other components / services, so things like the web layer or the database layer, should be tested on
  the integraton test level!
- Business use cases should have an end-to-end test for the happy path!
- Strive for meaningful error messages with assertions! Instead of `assertFalse(office.isEmpty());` use something like
```java
  assertThat(office)
  .as("The office should not be empty after an employee checked in.")
  .isNotEmpty();
```
- Follow the style described in the skill, not what you see in the codebase!
- There is no need to update tests with the wrong style, the codebase will be gradually become better!
- If the user or an automatic linter makes formatting or style changes to the code you wrote, accept it and don't force your own style!

### What makes a test good?

- Helps readers to understand how the tested thing works.
- Helps readers to understand the business process.
- Ensures that a business process works.
- Readable, focuses on the business process, not the technical necessities and boilerplate.
    - To achieve this, a BDD style is preferred, where the test method only contains high level concepts. For example:
```java
  @Test
  void shouldChangeFieldsToFooFromBar() {
    MyInputClass objectWithBar = givenAnInputContaining("bar");

    whenTheClassUnderTestHandles(objectWithBar);

    thenTheFieldChangedTo("foo");
  }
```

    - This makes the need of comments like `// given` unnecessary.
- Tests through APIs and interfaces whenever possible. For example directly writing to and reading from databases is
  only acceptable when testing how something stores data in the database.

