import 'package:caff_shop_app/app/stores/screen_stores/login_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test login store', () {
    LoginStore loginStore = LoginStore();

    const emailRight = 'test@mail.hu';
    const emailWrong1 = 'asd';
    const emailWrong2 = 'a@b@c.d';
    const passwordRight = 'Password12.';
    const empty = '';

    const error_field_is_empty = 'error.field_is_empty';
    const error_invalid_content = 'error.invalid_content';


    test('Validation right input', () {
      loginStore.email = emailRight;
      loginStore.password = passwordRight;
      expect(loginStore.validate(), true);
      expect(loginStore.emailError, null);
      expect(loginStore.passwordError, null);
    });

    test('Validation empty inputs', () {
      loginStore.email = empty;
      loginStore.password = empty;
      expect(loginStore.validate(), false);
      expect(loginStore.emailError, error_field_is_empty);
      expect(loginStore.passwordError, error_field_is_empty);
    });

    test('Validation wrong email', () {
      loginStore.email = emailWrong1;
      loginStore.password = passwordRight;
      expect(loginStore.validate(), false);
      expect(loginStore.emailError, error_invalid_content);
      expect(loginStore.passwordError, null);
    });

    test('Validation wrong email', () {
      loginStore.email = emailWrong2;
      loginStore.password = passwordRight;
      expect(loginStore.validate(), false);
      expect(loginStore.emailError, error_invalid_content);
      expect(loginStore.passwordError, null);
    });
  });
}
