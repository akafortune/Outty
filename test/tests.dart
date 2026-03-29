import 'package:outty/features/chat/repositories/chat_repository.dart';
import 'package:outty/features/matching/models/match_criteria.dart';
import 'package:outty/features/matching/providers/matching_provider.dart';
import 'package:outty/features/matching/repositories/matching_repository.dart';
import 'package:outty/features/onboarding/providers/onboarding_provider.dart';
import 'package:outty/features/onboarding/repositories/onboarding_repository.dart';
import 'package:outty/features/profile/providers/profile_provider.dart';
import 'package:outty/features/profile/repositories/profile_repository.dart';
import 'package:test/test.dart';

void main() {
  //Unit Tests
  group('Unit Tests', () {
    test("Update name in onboarding provider works", () {
      final OnboardingProvider provider = OnboardingProvider(
        repository: OnboardingRepository(),
      );

      provider.updateName("Lisa");

      expect(provider.name, "Lisa");
    });

    test("Toggle interest on during onboarding", () {
      final OnboardingProvider provider = OnboardingProvider(
        repository: OnboardingRepository(),
      );

      provider.toggleInterest('Hiking');

      final likesHiking = provider.interests.contains('Hiking');

      expect(likesHiking, true);
    });

    test("Toggle interest off during onboarding", () {
      final OnboardingProvider provider = OnboardingProvider(
        repository: OnboardingRepository(),
      );

      provider.toggleInterest('Hiking');
      provider.toggleInterest('Hiking');

      final likesHiking = provider.interests.contains('Hiking');

      expect(likesHiking, false);
    });

    test("Add photos", () {
      final OnboardingProvider provider = OnboardingProvider(
        repository: OnboardingRepository(),
      );

      provider.addPhoto(
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
      );
      provider.addPhoto(
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      );

      final urls = [provider.photos[0], provider.photos[1]];

      expect(urls, [
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      ]);
    });

    test("Remove photos", () {
      final OnboardingProvider provider = OnboardingProvider(
        repository: OnboardingRepository(),
      );

      provider.addPhoto(
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
      );
      provider.addPhoto(
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      );
      provider.removePhoto(
        'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
      );

      final urls = [provider.photos[0]];

      expect(urls, [
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2',
      ]);
    });

    test("Get Match Works", () async {
      final MatchingRepository repo = MatchingRepository();

      final matchList = await repo.getMatches(MatchCriteria());

      final profileName = matchList[1].name;

      expect(profileName, 'Sophia');
    });

    test("Search Match ID Works", () async {
      final MatchingRepository repo = MatchingRepository();

      final match = await repo.getMatchById('2');

      final profileName = match.name;

      expect(profileName, 'Michael');
    });

    test("Get Chat Room By Match ID Works", () async {
      final ChatRepository repo = ChatRepository();

      final chatRoom = await repo.getChatRoomByMatchId('current_user', '1');

      final lastMessage = chatRoom?.lastMessage?.content;

      expect(lastMessage, 'Hey, how are you doing?');
    });

    test("Get Chat Room By Room ID Works", () async {
      final ChatRepository repo = ChatRepository();

      final messages = await repo.getChatMessages('2');

      final lastMessage = messages[1].content;

      expect(
        lastMessage,
        'Yes! I try to go every weekend when the weather is nice.',
      );
    });

    test("Initialized with no premium badges", () async {
      final MatchingProvider provider = MatchingProvider(
        repository: MatchingRepository(),
      );

      final badges = provider.getPremiumBadges();

      expect(badges.length, 0);
    });
  });

  group('TDD', () {
    //TDD Tests
    //initial test: want to make a clear account feature that clears the user's current matched account, stored error text and exclusive content

    //Test 1: clear current matched account
    test("Clear Stored Match", () async {
      final MatchingProvider provider = MatchingProvider(
        repository: MatchingRepository(),
      );

      provider.clearProfile();

      expect(provider.currentProfile, null);
    });

    test("Clear Error Text", () async {
      final MatchingProvider provider = MatchingProvider(
        repository: MatchingRepository(),
      );

      provider.clearProfile();

      expect(provider.error, null);
    });

    test("Clear Exclusive Content", () async {
      final MatchingProvider provider = MatchingProvider(
        repository: MatchingRepository(),
      );

      provider.clearProfile();

      expect(provider.exclusiveContent?.length, 0);
    });
  });
}
