// Phạm vi Y Quán: khám ngoại trú theo YHCT và nội YHCT. Không tiếp nhận cấp cứu.
// Ca có dấu hiệu cấp cứu bị loại khỏi kho ca luyện và không được đưa vào phòng khám.
export const SCOPE_NOTICE = 'Phạm vi Y Quán: khám ngoại trú theo YHCT và nội YHCT. Không tiếp nhận cấp cứu; tình huống cấp cứu cần đến cơ sở y tế gần nhất.';
export const SCOPE_REFERRAL = 'Bệnh cảnh này có dấu hiệu cần cấp cứu hoặc vượt phạm vi Y Quán nên không đưa vào ca luyện. Hãy chuyển đến cơ sở y tế gần nhất.';

export const RED_FLAG_FINDINGS = new Set([
  'hematemesis',
  'melena',
  'chest-pain-spread',
  'syncope',
  'convulsion',
  'severe-dyspnea',
  'stiff-neck-high-fever',
]);

export function outOfScopeReason(caseFile) {
  const findings = Array.isArray(caseFile?.keyFindings) ? caseFile.keyFindings : [];
  return findings.some(id => RED_FLAG_FINDINGS.has(id)) ? 'red-flag' : '';
}

export function inScopeCases(cases) {
  return cases.filter(item => !outOfScopeReason(item));
}
