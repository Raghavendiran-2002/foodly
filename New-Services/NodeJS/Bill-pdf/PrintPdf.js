var p = require("pdf-to-printer");
async function print() {
  //   try {
  //     await p.getPrinters().then(console.log);
  //     console.log("stated");
  //     p.getPrinters().then(console.log);
  //   } catch (e) {
  //     print(e);
  //   }
}

// print();
console.log("stated");
p.getPrinters().then(console.log);
