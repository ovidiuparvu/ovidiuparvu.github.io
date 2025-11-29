---
layout: post
title: Running C# files w/o a project
comments: true
tags: [csharp,script,run]
---

Since .NET10 Preview 4 it is possible to [run](https://devblogs.microsoft.com/dotnet/announcing-dotnet-run-app/) a C# file w/o creating a C# project.

```bash
cat >/tmp/app.cs <<EOF
#!/usr/bin/dotnet run
Console.WriteLine("Hello world!");
EOF
chmod +x /tmp/app.cs
/tmp/app.cs
```