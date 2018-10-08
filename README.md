# dockerized-headless-lightning
Docker orchestration for Drupal's headless-lightning build.

### Deploy (these instructions maybe outdated; pm me for details)
1. Clone the repository
`$ git clone git@github.com:kavibk/dockerized-headless-lightning.git`

2. Navigate into the repository
`$ cd dockerized-headless-lightning.git`

3. Run docker-compose
`$ docker-compose up --build`

4. Navigate to headless-lightning (read below for credentials)
`$ http get localhost:80`
---
`kavi-drupal |  [success] Installation complete.  User name: admin  User password: 9KZ8JMyjBX`

In your docker output, you should see a line with your web interface credentials.

Go ahead and navigate to `http://localhost` and login with the automatically generated credentials.

If you have any questions, comments, or concerns please submit an issue request to Github, PM me in slack, or send me an email.

`kaden@vermilion.tech`
