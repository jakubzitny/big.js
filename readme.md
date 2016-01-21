# a crawler

I crawl top XX JavaScript repositories from GitHub.

## crawled structure of single project
- `bare_repo/`
- `latest/`
- `github/`
- `github/info.json`
- `github/contributors.json`
- `github/languages.json`
- `github/forks.json`
- `github/tags.json`
- `github/releases.json`
- `github/branches.json`
- `github/labels.json`
- `github/milestones.json`
- `github/prs.json`
- `github/issues.json`
- `github/commits.json`
- `github/stargazers.json`
- `github/totalSize.json`
- `index.json`

## Contents of `index.json`
```
{
  "corpus_release": "1.0",
  "code": "./latest",
  "site_specific_id": 16347517,
  "git_bare_repo": "./bare_repo",
  "crawler_metadata": [
    "./github/info.json",
    "./github/contributors.json",
    "./github/languages.json",
    "./github/forks.json",
    "./github/tags.json",
    "./github/releases.json",
    "./github/branches.json",
    "./github/labels.json",
    "./github/milestones.json",
    "./github/prs.json",
    "./github/issues.json",
    "./github/commits.json",
    "./github/stargazers.json",
    "./github/totalSize.json"
  ],
  "name": "kkruecke/radix-sort",
  "site": "github",
  "repo": "github",
  "on_disk_ver": "1.2",
  "crawled_date": "2015-05-19T05:01:49.938Z",
  "uuid": "0000fd51-6089-437d-a058-ef34de8cad7a"
}
```
