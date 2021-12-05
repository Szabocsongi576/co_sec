import 'package:caff_shop_app/app/stores/screen_stores/login_store.dart';
import 'package:caff_shop_app/app/stores/screen_stores/register_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  RegisterStore registerStore = RegisterStore();
  LoginStore loginStore = LoginStore();

  const userNameRight = 'Teszt Felhasználó';
  const userNameWrong = '.-!£';
  const emailRight = 'test@mail.hu';
  const emailWrong1 = 'asd';
  const emailWrong2 = 'a@b@c.d';
  const passwordRight = 'Password12.';
  const password = 'pass';
  const passwordConfirmation = 'word';
  const empty = '';

  const error_field_is_empty = 'error.field_is_empty';
  const error_invalid_content = 'error.invalid_content';
  const error_passwords_different = 'error.passwords_different';

  group('Test register store', () {

    test('Validation right input', () {
      registerStore.username = userNameRight;
      registerStore.email = emailRight;
      registerStore.password = passwordRight;
      registerStore.passwordConfirmation = passwordRight;
      expect(registerStore.validate(), true);
      expect(registerStore.usernameError, null);
      expect(registerStore.emailError, null);
      expect(registerStore.passwordError, null);
      expect(registerStore.passwordConfirmationError, null);
    });

    test('Validation empty inputs', () {
      registerStore.username = empty;
      registerStore.email = empty;
      registerStore.password = empty;
      registerStore.passwordConfirmation = empty;
      expect(registerStore.validate(), false);
      expect(registerStore.usernameError, error_field_is_empty);
      expect(registerStore.emailError, error_field_is_empty);
      expect(registerStore.passwordError, error_field_is_empty);
      expect(registerStore.passwordConfirmationError, error_field_is_empty);
    });

    test('Validation wrong email 1', () {
      registerStore.username = userNameRight;
      registerStore.email = emailWrong1;
      registerStore.password = passwordRight;
      registerStore.passwordConfirmation = passwordRight;
      expect(registerStore.validate(), false);
      expect(registerStore.usernameError, null);
      expect(registerStore.emailError, error_invalid_content);
      expect(registerStore.passwordError, null);
      expect(registerStore.passwordConfirmationError, null);
    });

    test('Validation wrong email 2', () {
      registerStore.username = userNameRight;
      registerStore.email = emailWrong2;
      registerStore.password = passwordRight;
      registerStore.passwordConfirmation = passwordRight;
      expect(registerStore.validate(), false);
      expect(registerStore.usernameError, null);
      expect(registerStore.emailError, error_invalid_content);
      expect(registerStore.passwordError, null);
      expect(registerStore.passwordConfirmationError, null);
    });

    test('Validation different password', () {
      registerStore.username = userNameRight;
      registerStore.email = emailRight;
      registerStore.password = password;
      registerStore.passwordConfirmation = passwordConfirmation;
      expect(registerStore.validate(), false);
      expect(registerStore.usernameError, null);
      expect(registerStore.emailError, null);
      expect(registerStore.passwordError, null);
      expect(registerStore.passwordConfirmationError, error_passwords_different);
    });
  });

  group('Test login store', () {

    test('Validation right input', () {
      loginStore.username = userNameRight;
      loginStore.password = passwordRight;
      expect(loginStore.validate(), true);
      expect(loginStore.usernameError, null);
      expect(loginStore.passwordError, null);
    });

    test('Validation empty inputs', () {
      loginStore.username = empty;
      loginStore.password = empty;
      expect(loginStore.validate(), false);
      expect(loginStore.usernameError, error_field_is_empty);
      expect(loginStore.passwordError, error_field_is_empty);
    });
  });
}
