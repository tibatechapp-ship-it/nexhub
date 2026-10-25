class GithubUser {
  final String login;
  final String? avatarUrl;
  final String? name;
  final String? bio;
  final int publicRepos;
  final int followers;

  GithubUser({
    required this.login,
    this.avatarUrl,
    this.name,
    this.bio,
    this.publicRepos = 0,
    this.followers = 0,
  });

  factory GithubUser.fromJson(Map<String, dynamic> json) {
    return GithubUser(
      login: json['login'] ?? '',
      avatarUrl: json['avatar_url'],
      name: json['name'],
      bio: json['bio'],
      publicRepos: json['public_repos'] ?? 0,
      followers: json['followers'] ?? 0,
    );
  }
}

class GithubRepo {
  final int id;
  final String name;
  final String fullName;
  final String? description;
  final String? language;
  final int stargazersCount;
  final bool isPrivate;
  final GithubUser owner;

  GithubRepo({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    this.language,
    this.stargazersCount = 0,
    this.isPrivate = false,
    required this.owner,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) {
    return GithubRepo(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
      description: json['description'],
      language: json['language'],
      stargazersCount: json['stargazers_count'] ?? 0,
      isPrivate: json['private'] ?? false,
      owner: GithubUser.fromJson(json['owner']),
    );
  }
}

class GithubIssue {
  final int number;
  final String title;
  final String state;
  final String? body;
  final GithubUser user;
  final DateTime createdAt;

  GithubIssue({
    required this.number,
    required this.title,
    required this.state,
    this.body,
    required this.user,
    required this.createdAt,
  });

  factory GithubIssue.fromJson(Map<String, dynamic> json) {
    return GithubIssue(
      number: json['number'],
      title: json['title'],
      state: json['state'],
      body: json['body'],
      user: GithubUser.fromJson(json['user']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
