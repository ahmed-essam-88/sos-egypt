import 'package:flutter_test/flutter_test.dart';
import 'package:sos_egypt/data/content.dart';
import 'package:sos_egypt/services/assistant.dart';
import 'package:sos_egypt/services/sos_service.dart';

void main() {
  test('official numbers are exactly the verified ones', () {
    final m = {for (final s in services) s.id: s.number};
    expect(m['ambulance'], '123');
    expect(m['police'], '122');
    expect(m['fire'], '180');
    expect(m['tourist'], '126');
    expect(m['traffic'], '128');
    expect(m['gas'], '129');
    expect(m['child'], '16000');
  });
  test('assistant classifies Egyptian Arabic and English', () {
    expect(analyze('في حريق في المطبخ').category.id, 'fire');
    expect(analyze('حد مش بيتنفس').immediateDanger, true);
    expect(analyze('حد مش بيتنفس').category.id, 'medical');
    expect(analyze('حصلت حادثة على الطريق').category.id, 'road');
    expect(analyze('someone is following me').category.id, 'threat');
    expect(analyze('what is fire prevention').immediateDanger, false);
    expect(analyze('xyz').matched, false);
  });
  test('phone normalisation and validation', () {
    expect(normalizePhone('0100 123 4567'), '+201001234567');
    expect(validPhone('01001234567'), true);
    expect(validPhone('12'), false);
  });
  test('every category has steps and a call target', () {
    for (final c in categories) {
      expect(c.stepsAr.isNotEmpty && c.stepsEn.isNotEmpty, true);
      expect(c.stepsAr.length, c.stepsEn.length);
      for (final id in c.call) {
        svcById(id);
      }
    }
  });
}
