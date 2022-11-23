
git pull
t=$(git describe --tags `git rev-list --tags --max-count=1`)
echo $t 
echo "$t" > test.txt
git add .
git commit -m "new tag"
git push
