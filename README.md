# ROR Test ![Ruby](https://github.com/iagopiimenta/showoff-tech-test-ror/workflows/Ruby/badge.svg)

Source: https://github.com/iagopiimenta/showoff-tech-test-ror

- This application was built to run as a wrapper for the [showoff-rails-react-production api](https://showoff-rails-react-production.herokuapp.com/)
- The API is documented at [getpostman.com](https://documenter.getpostman.com/view/263900/RztoL8FR?version=latest#1da840cb-5870-43d9-bcad-44c998a8d3ee)

## Demo

Visit https://showoff-tech-test-ror.herokuapp.com/

## Running locally(docker)

1 - Create a `docker-compose.override.yml` file with a `env_file`:

```bash
echo "version: '3.7'
services:
  app:
    env_file:
      - .env.development
" > docker-compose.override.yml
```

2 - Create a `.env.development` file with your credentials:

```bash
echo "SHOWOFF_CLIENT=YOUR_SHOWOFF_CLIENT
SHOWOFF_CLIENT_SECRET=YOUR_SHOWOFF_CLIENT_SECRET
SHOWOFF_API_URL=https://showoff-rails-react-production.herokuapp.com
" > .env.development
```

3 - Run `docker-compose up`

4 - Go to  http://localhost:3050
