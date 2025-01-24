extension Durationextension on Duration {
  String formatToHoursMinutesAndSeconds() {
    return '${inHours.remainder(24).toString().padLeft(2, '0')} : ${inMinutes.remainder(60).toString().padLeft(2, '0')} : ${(inSeconds.remainder(60)).toString().padLeft(2, '0')}';
  }
}