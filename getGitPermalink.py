"""Get permalink to git commit for a specific path.
written by Kenneth Daily (@kdaily)
"""

import os
import ConfigParser
import github

def getToken():
    """Authenticate using a token.

    """

    config = ConfigParser.ConfigParser()
    config.readfp(file(os.path.expanduser('~/.pygit')))

    mytoken = config.get('authentication', 'token')

    return mytoken

_base_raw = "https://raw.github.com"
_base_web = "https://github.com"

def makeRawPermalink(repo, commit, path):
    permalink = "%(base)s/%(repo)s/%(commit)s/%(path)s" % dict(base=_base_raw,
                                                               repo=repo,
                                                               commit=commit,
                                                               path=path)
    return permalink

def makeWebPermalink(repo, commit, path):
    permalink = "%(base)s/%(repo)s/blob/%(commit)s/%(path)s" % dict(base=_base_web,
                                                                    repo=repo,
                                                                    commit=commit,
                                                                    path=path)
    return permalink


def getPermalink(gh, repo, path, ref="master", raw=True):
    ## Get the repo
    repoobj = gh.get_repo(repo)

    ## Get a specific ref
    refobj = repoobj.get_git_ref("heads/%s" % ref)

    ## Get the commit object for this ref
    commit = repoobj.get_commit(refobj.object.sha)

    ## Get tree
    tree = repoobj.get_git_tree(commit.sha, recursive=True)

    try:
        myfile = filter(lambda x: x.path == path, tree.tree)[0]
    except IndexError as e:
        raise(IndexError, "Not Found!")

    if raw:
        permalink = makeRawPermalink(repo=repo, commit=refobj.object.sha, path=path)
    else:
        permalink = makeWebPermalink(repo=repo, commit=refobj.object.sha, path=path)

    return permalink

def main():
    """Get permalink to most recent commit of a file in Github.

    Currently requires that you keep your API token in a config file (in a section called 'authentication', variable for 'token').

    Example:
    >>> authtoken = getToken()
    >>> g = github.Github(authtoken)
    >>> permalink = getPermalink(gh=g, repo="Sage-Bionetworks/synapsePythonClient", ref="develop", path="synapseclient/client.py")

    This follows suggestions from this StackOverflow post:
    http://stackoverflow.com/questions/15919635/on-github-api-what-is-the-best-way-to-get-the-last-commit-message-associated-w

    """

    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=str)
    parser.add_argument("--ref", type=str, default="master")
    parser.add_argument("--path", type=str)
    parser.add_argument("--web", action="store_true", default=False)

    args = parser.parse_args()

    authtoken = getToken()
    g = github.Github(authtoken)

    raw = not args.web
    permalink = getPermalink(gh=g, repo=args.repo,
                             ref=args.ref, path=args.path,
                             raw=raw)

    print permalink

if __name__ == "__main__":
    main()
