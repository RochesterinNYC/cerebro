# Cerebro

Search through github forks of a repo for search terms!
Great for maintainers that want to know what downstream forks are doing.

## Installation

Install it with:

```bash
$ gem install cerebro
```

## Details

Cerebro currently works by using the Github API to identify all the forks of the
repo if interest. It then will clone all the repos down into a specifically named
repo under the `$HOME/.cerebro` directory. It will then use grep searching to
determine if your search term is present in each/which of the forks.

## Usage

- Cloning down of the repos will be shallow by default. If you want deep clones, use `cerebro search --deep`.

####Searching:

- To clean up all repos that Cerebro has cloned onto your local file system:

```bash
$ GITHUB_TOKEN=<github_api_token> cerebro search <repo_owner> <repo_name> <search_term>
```

For example, if I'm looking to determine how many forks of the [Cloud Foundry python buildpack](https://github.com/cloudfoundry/python-buildpack)
have been forked to add or use `graphviz`, I might run:

```
GITHUB_TOKEN=<github_token> cerebro search cloudfoundry python-buildpack graphviz
Found 85 forks of cloudfoundry/python-buildpack
All forks will be stored in /Users/user/.cerebro/python-buildpack-forks
Cloning or updating all local fork repos...
<...>
Searching through these forks now...

----------------Search Results---------------------
Found graphviz in kdunn-pivotal-python-buildpack
Found graphviz in ssssam-python-buildpack

Found "graphviz" in 2 forks out of total 85 forks of cloudfoundry/python-buildpack

Clones of forked repos are located in /Users/user/.cerebro/python-buildpack-forks
```

####Cleaning Up:

- To clean up all repos that Cerebro has cloned onto your local file system:

```bash
$ cerebro clean --all
```

- To clean up only the repos that are forks for a specific repo:

```bash
$ cerebro clean <repo-name>
```

## Dependencies

- This gem relies on `git` for cloning down forks of repos.
- This gem currently relies on $HOME being set on your machine for figuring out where to store cloned repos.
- This gem's searching for forks relies on the user providing a valid Github API token via
  `GITHUB_TOKEN` env vars. This token is not persisted or stored at all.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/RochesterinNYC/cerebro or in https://cloudfoundry.slack.com/messages/buildpacks/.

## Later Work

- Make dirnames specific to owner and repo name instead of just repo name
- Command for cleaning up stored repos
- Specify where to store cloned repos
- Option for auto-clean up afterwards
- Better UX for specifying github auth
- Remove dependency on octokit
- Threading for parallel cloning
- Search caching?

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
