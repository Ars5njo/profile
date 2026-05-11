class GitHubUserStats {
  const GitHubUserStats({
    required this.publicRepos,
    required this.followers,
    required this.following,
    required this.updatedAt,
  });

  final int? publicRepos;
  final int? followers;
  final int? following;
  final DateTime? updatedAt;
}

class CodeforcesUserStats {
  const CodeforcesUserStats({
    required this.rating,
    required this.maxRating,
    required this.rank,
    required this.contribution,
    required this.city,
    required this.organization,
  });

  final int? rating;
  final int? maxRating;
  final String? rank;
  final int? contribution;
  final String? city;
  final String? organization;
}

class LeetCodeUserStats {
  const LeetCodeUserStats({
    required this.totalSolved,
    required this.easySolved,
    required this.mediumSolved,
    required this.hardSolved,
    required this.ranking,
  });

  final int? totalSolved;
  final int? easySolved;
  final int? mediumSolved;
  final int? hardSolved;
  final int? ranking;
}

class GitHubRepositoryStats {
  const GitHubRepositoryStats({
    required this.totalCommits,
    required this.authorCommits,
    required this.stars,
    required this.forks,
    required this.topics,
    required this.languages,
  });

  final int? totalCommits;
  final int? authorCommits;
  final int? stars;
  final int? forks;
  final List<String> topics;
  final List<String> languages;
}

class GitHubSearchStats {
  const GitHubSearchStats({
    required this.totalCount,
    required this.firstRepositoryName,
    required this.firstRepositoryUrl,
  });

  final int? totalCount;
  final String? firstRepositoryName;
  final String? firstRepositoryUrl;
}

class GitHubRepositoryRef {
  const GitHubRepositoryRef({required this.owner, required this.name});

  final String owner;
  final String name;

  String get url => 'https://github.com/$owner/$name';
}
