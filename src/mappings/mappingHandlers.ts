import { Agreement, Moderator } from '../types';
import {
	MoonbeamCall,
	MoonbeamEvent,
} from '@subql/contract-processors/dist/moonbeam';
import { CreateAgreementCallArgs, CreateEventArgs } from '../args';

type AttestEventArgs = [string, BigInt] & {
	to: string;
	tokenId: BigInt;
};

export async function handleCreateAgreementEvent(
	event: MoonbeamEvent<CreateEventArgs>
): Promise<void> {
	logger.warn('Calling CREATE');

	const moderatorAddr = event.args.moderator;
	const agreementId = event.args.agreementId;

	const moderator = await getModerator(moderatorAddr);

	moderator.experiencedDaos++;
	moderator.agreementIds.push(agreementId);

	moderator.save();
}

export const handleCreateAgreementCall = async (
	event: MoonbeamCall<CreateAgreementCallArgs>
) => {
	logger.warn('Calling handleCreateAgreementCall');

	if (!event.success) {
		logger.warn('CreateAgreement Call was not successful');
	}

	const {
		moderator,
		daoName,
		startTime,
		endTime,
		rewardAmount,
		vestingDuration,
	} = event.args;
	const founder = event.from;

	const agreement = await Agreement.create({
		id: event.hash,
		moderator,
		founder,
		daoName,
		startTime: new Date(startTime * 1000),
		endTime: new Date(endTime * 1000),
		rewardAmount: BigInt(rewardAmount),
		vestingDuration: BigInt(vestingDuration),
	});

	agreement.save();
};

export async function handleAttest(event: MoonbeamEvent<AttestEventArgs>) {
	logger.warn('Calling ATTEST');

	const { to, tokenId } = event.args;

	const moderator = await getModerator(to);

	moderator.tokenIds.push(BigInt(tokenId.toString()));

	moderator.save();
}

export async function handleUpdateAgreement(
	event: MoonbeamCall<CreateAgreementCallArgs>
) {
	logger.warn('Calling UPDATE');

	if (!event.success) {
		logger.warn('CreateAgreement Call was not successful');
	}

	const {
		moderator,
		daoName,
		startTime,
		endTime,
		rewardAmount,
		vestingDuration,
	} = event.args;
	const founder = event.from;

	const agreement = await Agreement.create({
		id: event.hash,
		moderator,
		founder,
		daoName,
		startTime: new Date(startTime * 1000),
		endTime: new Date(endTime * 1000),
		rewardAmount: BigInt(rewardAmount),
		vestingDuration: BigInt(vestingDuration),
	});

	agreement.save();
}

// export async function handleCreateAgreement(
// 	event: MoonbeamCall<CreateAgreementCallArgs>
// ) {
// 	if (!event.success) return;

// 	logger.warn('Calling handleCreateAgreement');

// 	// const founderAddr = event.from;
// 	// const moderatorAddr = event.args.moderator;

// 	// const founderWallet = await doSomething(founderAddr);
// 	// const moderatorWallet = await doSomething(moderatorAddr);

// 	// const account = await Moderator.get(moderatorAddr);
// }

// // export async function handleEVMCall(call: MoonbeamCall): Promise<void> {

// //     logger.warn('calling handleEVMCall');

// //     logger.warn(`CALL DATA ${JSON.stringify(call)}`);
// // }

export const getModerator = async (address: string): Promise<Moderator> => {
	const moderator = await Moderator.get(address);

	if (moderator) return moderator;

	return await Moderator.create({
		id: address,
		hasEns: false,
		experiencedDaos: 0,
		agreementIds: [],
		tokenIds: [],
	});
};
