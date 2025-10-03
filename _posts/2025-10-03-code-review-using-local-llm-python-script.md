---
layout: post
title: Python script for performing a code review using local LLMs
comments: true
tags: [llm,review,local,claude]
---

Claude created the following Python script for performing a code review using local LLMs after I interacted with it for 5 minutes:

````python
#!/usr/bin/env python3
"""
Git Code Review using local LLMs via simonw's llm tool.
Performs code reviews on git changes as a world-class senior software engineer.
"""

import subprocess
import sys
import typer
from typing import Optional
from pathlib import Path


app = typer.Typer(
    help="Perform AI-powered code review on git changes using local LLMs",
    add_completion=False
)


def run_command(cmd, check=True):
    """Run a shell command and return output."""
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            capture_output=True,
            text=True,
            check=check
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        typer.echo(f"Error running command: {cmd}", err=True)
        typer.echo(f"Error: {e.stderr}", err=True)
        raise typer.Exit(1)


def get_git_diff(target_branch=None):
    """Get git diff for review."""
    if target_branch:
        cmd = f"git diff {target_branch}...HEAD"
    else:
        cmd = "git diff HEAD"
    
    diff = run_command(cmd)
    
    if not diff:
        typer.echo("No changes found to review.", err=True)
        raise typer.Exit(0)
    
    return diff


def get_changed_files(target_branch=None):
    """Get list of changed files."""
    if target_branch:
        cmd = f"git diff --name-only {target_branch}...HEAD"
    else:
        cmd = "git diff --name-only HEAD"
    
    files = run_command(cmd)
    return files.split('\n') if files else []


def create_review_prompt(diff, files, context=""):
    """Create a comprehensive code review prompt."""
    prompt = (
        f"""You are a world-class senior software engineer performing a thorough code review. Review the following 
    git changes with expertise in software architecture, design patterns, performance, security, and best practices.

CHANGED FILES:
{chr(10).join(f"- {f}" for f in files)}

CODE CHANGES:
```diff
{diff}
```

{f"ADDITIONAL CONTEXT:{chr(10)}{context}{chr(10)}" if context else ""}
Please provide a comprehensive code review covering:

1. **Critical Issues** - Bugs, security vulnerabilities, or breaking changes
2. **Architecture & Design** - Design patterns, SOLID principles, code organization
3. **Code Quality** - Readability, maintainability, naming conventions
4. **Performance** - Potential bottlenecks or optimization opportunities
5. **Testing** - Test coverage considerations and edge cases
6. **Best Practices** - Language-specific idioms and conventions
7. **Positive Feedback** - What was done well

For each issue found:
- Specify the severity (CRITICAL/HIGH/MEDIUM/LOW)
- Reference the specific file and approximate line
- Explain the problem clearly
- Suggest a concrete solution

Be thorough but constructive. If the changes look good, say so and explain why.
        """
    )
    return prompt


def review_with_llm(prompt, model=None):
    """Send prompt to llm and get review."""
    typer.echo("🔍 Analyzing code changes...\n", err=True)
    
    # Build llm command
    cmd = ["llm"]
    if model:
        cmd.extend(["-m", model])
    
    # Use subprocess.Popen for streaming output
    process = subprocess.Popen(
        cmd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    
    # Send prompt and get response
    stdout, stderr = process.communicate(input=prompt)
    
    if process.returncode != 0:
        typer.echo(f"Error from llm: {stderr}", err=True)
        raise typer.Exit(1)
    
    return stdout


@app.command()
def main(
    branch: Optional[str] = typer.Option(
        None,
        "--branch",
        "-b",
        help="Review changes against specified branch (e.g., main, develop)"
    ),
    model: Optional[str] = typer.Option(
        None,
        "--model",
        "-m",
        help="Specify llm model to use (e.g., llama2, mistral)"
    ),
    context: str = typer.Option(
        "",
        "--context",
        "-c",
        help="Additional context for the review"
    ),
):
    """
    Review git changes using a local LLM.
    
    Examples:
    
        git-review                          # Review uncommitted changes
        
        git-review --branch main            # Review changes vs main branch
        
        git-review -m llama2                # Use specific model
        
        git-review --context "Security fix" # Add context
    """
    # Check if we're in a git repository
    try:
        run_command("git rev-parse --git-dir", check=True)
    except:
        typer.echo("Error: Not in a git repository", err=True)
        raise typer.Exit(1)
    
    # Get the diff and changed files
    diff = get_git_diff(target_branch=branch)
    files = get_changed_files(target_branch=branch)
    
    # Create review prompt
    prompt = create_review_prompt(diff, files, context)
    
    # Get review from LLM
    review = review_with_llm(prompt, model=model)
    
    # Output review
    typer.echo("\n" + "="*80)
    typer.echo("CODE REVIEW")
    typer.echo("="*80 + "\n")
    typer.echo(review)
    
    typer.echo("\n" + "="*80, err=True)
    typer.echo("✨ Review complete!", err=True)


if __name__ == "__main__":
    app()
````

The world we live in...