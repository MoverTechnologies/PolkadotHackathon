import { Transfer } from '../types';
import {
	MoonbeamCall,
	MoonbeamEvent,
} from '@subql/contract-processors/dist/moonbeam';
import { BigNumber } from '@ethersproject/bignumber';

type AttestEventArgs = [string, BigNumber] & {
	moderator: string;
	agreementId: BigNumber;
};

// export async function handleAttest(
// 	event: MoonbeamEvent<AttestEventArgs>
// ): Promise<void> {
// 	logger.warn('Calling handleAttest');
// 	logger.warn('event.args._to : ', event.args._to);
// 	logger.warn('event.args._tokenId : ', event.args._tokenId);
// 	logger.warn('event.address : ', event.address);
// 	logger.warn('event.topics : ', event.topics);
// 	logger.warn('event.logIndex : ', event.logIndex);
// 	logger.warn('event.data : ', event.data);

// 	// const transfer = Transfer.create({
// 	// 	amount: event.args.value.toBigInt(),
// 	// 	from: event.args.from,
// 	// 	to: event.args.to,
// 	// 	contractAddress: event.address,
// 	// 	blockNumber: BigInt(event.blockNumber),
// 	// 	id: event.transactionHash,
// 	// });

// 	// await transfer.save();
// }

export async function handleCreateAgreement(
	event: MoonbeamEvent<AttestEventArgs>
): Promise<void> {
	logger.warn('Calling handleCreateAgreement');
	logger.warn('event.args.moderator : ', event.args.moderator);
	logger.warn('event.args.agreementId : ', event.args.agreementId);
	logger.warn('event.address : ', event.address);
	logger.warn('event.topics : ', event.topics);
	logger.warn('event.logIndex : ', event.logIndex);
	logger.warn('event.data : ', event.data);

	// const transfer = Transfer.create({
	// 	amount: event.args.value.toBigInt(),
	// 	from: event.args.from,
	// 	to: event.args.to,
	// 	contractAddress: event.address,
	// 	blockNumber: BigInt(event.blockNumber),
	// 	id: event.transactionHash,
	// });

	// await transfer.save();
}

// export async function handleEVMCall(call: MoonbeamCall): Promise<void> {

//     logger.warn('calling handleEVMCall');

//     logger.warn(`CALL DATA ${JSON.stringify(call)}`);
// }
