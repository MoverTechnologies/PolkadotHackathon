import { Transfer } from "../types";
import { MoonbeamCall, MoonbeamEvent } from '@subql/contract-processors/dist/moonbeam';
import { BigNumber } from '@ethersproject/bignumber';

type TransferEventArgs = [string, string, BigNumber] & { from: string; to: string; value: BigNumber; };


export async function handleERC20Transfer(event: MoonbeamEvent<TransferEventArgs>): Promise<void> {
    logger.warn('Calling handleERC20Transfer');

    const transfer = Transfer.create({
        amount: event.args.value.toBigInt(),
        from: event.args.from,
        to: event.args.to,
        contractAddress: event.address,
        blockNumber: BigInt(event.blockNumber),
        id: event.transactionHash,
    });

    await transfer.save();
}


// export async function handleEVMCall(call: MoonbeamCall): Promise<void> {

//     logger.warn('calling handleEVMCall');

//     logger.warn(`CALL DATA ${JSON.stringify(call)}`);
// }
