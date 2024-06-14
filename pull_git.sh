#!/bin/bash
git init
read -p "please enter your https_url_git:" https_url_git 
echo "your commit notes is $https_url_git"
git remote add origin "$https_url_git"
git pull origin main
