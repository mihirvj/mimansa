git add .
git commit -m "final 8"
git push heroku master
heroku run rake db:migrate
