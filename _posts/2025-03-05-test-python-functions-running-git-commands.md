---
layout: post
title: Testing Python functions running git commands
comments: true
tags: [test,python,git]
---

Let us assume that we would like to implement some Python functions that use the `subprocess` module to run some git commands. The question is how would you (unit) test such functions?

## Sample Python function running a git command

First of all let's consider the sample Python function below that runs a git command to determine the current git branch.

```python
def current_branch(path: str | Path = '.') -> str | None:
    try:
        result = subprocess.run(
            ['git', 'rev-parse', '--abbrev-ref', 'HEAD'],
            cwd=path,
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        return None
```

## How can we test Python functions running git commands?

To test the function above one can write a helper function that initializes a git repo in a temporary test directory and then runs the tests against this directory.

```python
@pytest.fixture
def temp_git_repo(tmp_path: Path) -> Path:
    os.chdir(tmp_path)
    subprocess.run(['git', 'init'], check=True)
    subprocess.run(['git', 'config', 'user.name', 'Test User'], check=True)
    subprocess.run(['git', 'config', 'user.email', 'test@example.com'], check=True)
    
    test_file = tmp_path / "test.txt"
    test_file.write_text("test content")
    subprocess.run(['git', 'add', '.'], check=True)
    subprocess.run(['git', 'commit', '-m', 'Initial commit'], check=True)
    
    return tmp_path

def test_current_branch_main(temp_git_repo: Path) -> None:
    assert current_branch(temp_git_repo) in ['main', 'master']
```

Source code is made available on [GitHub](https://github.com/ovidiuparvu/python-git-function-testing/tree/main) illustrating the testing approach described in this post.
