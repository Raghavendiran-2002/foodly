module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: ["eslint:recommended", "google"],
  rules: {
    indent: ["warn", 2],
    quotes: ["error", "double"],
  },
  parserOptions: {
    // Required for certain syntax usages
    ecmaVersion: 2020,
  },
};
