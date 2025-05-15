# Contributing to RoboKit

Thank you for your interest in contributing to the RoboKit SwiftPM framework! We welcome improvements, bug fixes, new features, and documentation enhancements. Please follow the guidelines below to ensure a smooth collaboration.

---

## 1. Getting Started

* **Fork** the repository to your GitHub account.
* **Clone** your fork:

  ```bash
  git clone git@github.com:Spacial-Dragons/RoboKit.git
  cd RoboKit
  ```
* **Install** dependencies and verify the project builds in Xcode.

---

## 2. Branch Naming

Use clear, consistent branch names based on the work type:

| Type    | Prefix  | Example                   |
| ------- | ------- | ------------------------- |
| Feature | `feat/` | `feat/physics-engine`     |
| Bug Fix | `fix/`  | `fix/collision-detection` |
| Hotfix  | `hot/`  | `hot/crash-on-launch`     |

The `main` branch always reflects stable, production-ready code.

---

## 3. Commit Guidelines

* Write **clear, concise** commit messages.
* Use the imperative mood (e.g., “Add support for...” not “Added support for...”).
* Reference issues when applicable (e.g., `fix #123`).

---

## 4. Pre-Submission Checklist

Before opening a Pull Request:

* [ ] Write **unit tests** for any new or modified functionality.
* [ ] Ensure all unit tests **pass** locally.
* [ ] Run **SwiftLint** and fix **all** warnings/errors.

* See our SwiftLint guide: [SwiftLint Guidelines](#SwiftLint)

---

## 5. Code Review Process

1. **Create a Pull Request (PR)**
   * Open a PR from your feature branch against `main`.
   
2. **Assign Reviewers**
   * Add **two** developers as reviewers.
   
3. **Reviewers’ Responsibilities**
   * Pull the branch locally.
   * Review code and either **approve** or leave **comments**.
   * Verify new code is covered by tests and CI checks (unit tests + SwiftLint) pass.
   
4. **Iteration**
   * Address feedback, push updates, and repeat until both reviewers approve.

---

## 6. Design Review

Once code reviewers have approved:

* A **designer** will review UI/UX and design consistency.
* They will **approve** or leave **comments** requesting improvements.
* Incorporate design feedback before merging.

---

## 7. Merging

After approvals and a green CI pipeline:

* The PR author may **merge** into `main`.
* Delete your branch after merging to keep the repo clean.

---

## 8. SwiftLint

**What is SwiftLint?**

A tool enforcing Swift style conventions and catching common mistakes early.

### Installing SwiftLint CLI

1. Install [Homebrew](https://brew.sh/) if needed.
2. Install SwiftLint:

   ```bash
   brew install swiftlint
   ```
3. **Automatically fix** warnings:

   ```bash
   swiftlint --fix
   ```

---

## 9. Documentation with DocC

**What is DocC?**

Generates and hosts documentation for Swift packages using structured Swift-Markdown comments.

### Writing Docs in Xcode

* **Real-time Preview**: Editor > Assistant > Documentation Preview.
* **Auto-Generate Templates**: Place cursor on a declaration and press `⌘⇧/`.

### DocC Markup Basics

````swift
/// <#Summary (1-line, starts with verb)#>
///
/// <#Overview paragraph#>
///
/// - Parameters:
///   - name: Description
/// - Returns: Description
///
/// > Note: Add any special directives.
///
/// ```swift
/// // Example code
/// ```
func greet(name: String) -> String { ... }
````

### Building Documentation

In Xcode: **Product > Build Documentation**.

---

## 10. Questions & Support

If you encounter issues or have questions, feel free to open an **issue** on GitHub.

Thank you for helping make RoboKit better! 🚀
