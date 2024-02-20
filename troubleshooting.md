# Troubleshooting

## No lsp
If you're using `--dart-define-from-file` & `config.json` to define environment variables:
- Make sure you have `config.json` file at the root of c-breez project
- Make sure you have `API_KEY` (upper case) with a valid key at your `config.json` file
- Make sure you are running flutter run with the following args `--dart-define-from-file=config.json`

If you're using `--dart-define` to define environment variables:
- Make sure you are running flutter run with the following args `--dart-define=API_KEY=<YOUR_API_KEY> --dart-define=GL_CERT=<YOUR_GL_CERT> --dart-define=GL_KEY=<YOUR_GL_KEY> --dart-define=APP_ID_PREFIX=<IOS_APP_ID_PREFIX>`

