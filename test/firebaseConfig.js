const { initializeTestEnvironment, firestore } = require('@firebase/rules-unit-testing');
const fs = require('fs');

const projectId = 'fin-app-v1-44109';

const testApp = initializeTestEnvironment({
  projectId,
  firestore: {
    rules: fs.readFileSync('../firestore.rules', 'utf8'),
  },
});

const app = testApp.app;
const adminApp = testApp.authenticatedContext;

module.exports = {
  app,
  adminApp,
};
