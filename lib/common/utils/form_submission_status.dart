abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class Initial extends FormSubmissionStatus {
  const Initial();
}

class Submitting extends FormSubmissionStatus {}

class Success extends FormSubmissionStatus {}

class Failed extends FormSubmissionStatus {
  Failed(this.exception);

  final Exception exception;
}
