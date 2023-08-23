import {ethers} from 'ethers';
import {getSqrtPriceX96FromPrice, TradeParams} from "@divergence-protocol/diver-sdk";
import {QuoterABI} from "./Quoter";


const url = "http://127.0.0.1:8545";
async function getLatestBlockNumber(): Promise<number> {
    const provider = new ethers.providers.JsonRpcProvider(url)
    const block = await provider.getBlockNumber();
    return block;
}

async function main() {
    const latestBlockNumber = await getLatestBlockNumber();
    console.log(`The latest block number is ${latestBlockNumber}`);

    const provider = new ethers.providers.JsonRpcProvider(url)
    const quoterContract = new ethers.Contract("0x68B1D87F95878fE05B998F19b66F4baba5De1aed", QuoterABI.abi, provider)

    let action = 0
    const sqrtX96Price = getSqrtPriceX96FromPrice(0)
    const args: TradeParams = {
      recipient: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
      tradeType: action,
      amountSpecified: ethers.utils.parseUnits("1000", 18).toString(),
      sqrtPriceLimitX96: sqrtX96Price.toFixed(),
      data: ethers.utils.formatBytes32String(''),
    }
    console.log('args', args)
    const result = await quoterContract.callStatic.quoteExactInput(args, "0x5564C65011218Db49B8DF9346dff6F56d5760c5a")
    console.log(result)
}

main().catch((error) => {
    console.error(error);
});
