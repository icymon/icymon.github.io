#!/bin/bash
git add .
read -p "please enter your commit notes:" notes 
echo "your commit notes is $notes"
git commit -m "$notes"
git branch -M main
git push -u origin main
