# github-action-push-to-another-repository

An action that copies several files or directories from one github repository to another, and commits the changes.

You could, for example, use this to copy a webpage generated by another github action to a directory in a github.io website automatically when the webpage repository is updated.

## Inputs
### `source-files` (argument)
The files/directories to copy to the destination repository. Can have multiple space-separated filenames and globbing.

### `destination-username` (argument)
The name of the user or organization which owns the destination repository. E.g. `nkoppel`

### `destination-repository` (argument)
The name of the repository to copy files to, E.g. `push-files-to-another-repository`

### `destination-branch` (argument) [optional]
The branch name for the destination repository. Defaults to `master`.

### `destination-directory` (argument) [optional]
The directory in the destination repository to copy the source files into. Defaults to the destination project root.

**We support multipe destination directories. In this mode, the number of words in `source-files` must be exactly same with the number of destination directories**


### `commit-username` (argument) [optional]
The username to use for the commit in the destination repository. Defaults to `destination-username`

### `commit-email` (argument)
The email to use for the commit in the destination repository.

### `commit-message` (argument) [optional]
The commit message to be used in the output repository. Defaults to "Update from [destination url]@[commit]".

The string `ORIGIN_COMMIT` is replaced by `[destination url]@[commit]`.

### `API_TOKEN_GITHUB` (environment)
The github api token which allows this action to push to the destination repository.
E.g.:
  `API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}`

To generate your personal token following the steps:
* Go to the Github Settings (on the right hand side on the profile picture)
* On the left hand side pane click on "Developer Settings"
* Click on "Personal Access Tokens" (also available at https://github.com/settings/tokens)
* Generate a new token, choose "Repo". Copy the token.

Then make the token available to the Github Action following the steps:
* Go to the Github page for the repository that you push from, click on "Settings"
* On the left hand side pane click on "Secrets"
* Click on "Add a new secret" and name it "API_TOKEN_GITHUB", and paste your personal token.

## Example usage
```yaml
      - name: Push generated webpage to another repository
        uses: nkoppel/push-files-to-another-repository@1.1.0
        env:
          API_TOKEN_GITHUB: ${{ secrets.API_TOKEN_GITHUB }}
        with:
          source-files: 'webpage/'
          destination-username: 'nkoppel'
          destination-repository: 'nkoppel.github.io'
          destination-directory: 'projects/my-project'
          commit-email: 'nathankoppel0@gmail.com'
```
