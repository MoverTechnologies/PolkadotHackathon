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
