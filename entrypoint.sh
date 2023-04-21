#!/bin/sh -l

set -e  # if a command fails exit the script
set -u  # script fails if trying to access an undefined variable

echo
echo "##### Starting #####"
SOURCE_FILES="$1"
DESTINATION_USERNAME="$2"
DESTINATION_REPOSITORY="$3"
DESTINATION_BRANCH="$4"
DESTINATION_DIRECTORY="$5"
COMMIT_USERNAME="$6"
COMMIT_EMAIL="$7"
COMMIT_MESSAGE="$8"

if [ -z "$COMMIT_USERNAME" ]
then
  COMMIT_USERNAME="$DESTINATION_USERNAME"
fi

CLONE_DIRECTORY=$(mktemp -d)

echo
echo "##### Cloning destination git repository #####"
# Setup git
git config --global user.email "$COMMIT_EMAIL"
git config --global user.name "$DESTINATION_USERNAME"
git clone --single-branch --branch "$DESTINATION_BRANCH" "https://$API_TOKEN_GITHUB@github.com/$DESTINATION_USERNAME/$DESTINATION_REPOSITORY.git" "$CLONE_DIRECTORY"
ls -la "$CLONE_DIRECTORY"

echo
echo "##### Copying contents to git repo #####"

# Create arrays by splitting the input strings by space
set -f
IFS=' '; words1=$(echo "$SOURCE_FILES")
IFS=' '; words2=$(echo "$DESTINATION_DIRECTORY")
set +f

# Get the length of the arrays
len1=$(echo "$words1" | wc -w)
len2=$(echo "$words2" | wc -w)

# Check if both input strings have the same number of words
if [ "$len1" -ne "$len2" ]; then
    echo "The input strings have different numbers of words."
    exit 1
fi

# Loop through the arrays and echo each pair of substrings
i=1
while [ $i -le $len1 ]; do
  word1=$(echo "$words1" | cut -d ' ' -f $i)
  word2=$(echo "$words2" | cut -d ' ' -f $i)
  mkdir -p "$CLONE_DIRECTORY/$word2"
  cp -rvf $word1 "$CLONE_DIRECTORY/$word2"
  i=$((i+1))
done

cd "$CLONE_DIRECTORY"
sudo apt-get install git-lfs
git-lfs install
git-lfs pull

echo
echo "##### Adding git commit #####"

ORIGIN_COMMIT="https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
COMMIT_MESSAGE="${COMMIT_MESSAGE/ORIGIN_COMMIT/$ORIGIN_COMMIT}"

git add .
git status

# don't commit if no changes were made
git diff-index --quiet HEAD || git commit --message "$COMMIT_MESSAGE"

echo
echo "##### Pushing git commit #####"
# --set-upstream: sets the branch when pushing to a branch that does not exist
git push origin --set-upstream "$DESTINATION_BRANCH"
