enum Grade {
  unknown,
  ten,
  eleven,
  twelve,
  undergraduate,
  graduate;

  // We give this enum these properties to make it
  // very easy to filter when searching for tutors
  // by what grades they can teach.

  bool operator <(Grade other) {
    return index < other.index;
  }

  bool operator >(Grade other) {
    return index > other.index;
  }

  bool operator <=(Grade other) {
    return index <= other.index;
  }

  bool operator >=(Grade other) {
    return index >= other.index;
  }
}
