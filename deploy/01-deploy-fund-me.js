//imports
//main
//invoke main

// async function deployMain() {
//     console.log("yo")
// }
// module.exports.default = deployMain

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, logs } = deployments
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId
}


// what happens when we want to change chains? 
// when going for localhost or hardhat network we want to go for a mock 