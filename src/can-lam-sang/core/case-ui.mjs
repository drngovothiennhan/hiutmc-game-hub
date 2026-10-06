export function renderReviewLabel(root, data) {
  const label = data?.review_label;
  const existing = root.querySelector('[data-review-label]');
  if (existing) existing.remove();
  if (label == null) return;
  const el = document.createElement('div');
  el.dataset.reviewLabel = '';
  el.setAttribute('role', 'note');
  el.textContent = label;
  root.prepend(el);
}

export function renderCase(root, data, { onSubmit } = {}) {
  root.replaceChildren();
  renderReviewLabel(root, data);
  const title = document.createElement('h1');
  title.textContent = data?.public_bundle?.title || data?.case_id || 'Ca lâm sàng';
  root.append(title);
  const body = document.createElement('div');
  body.textContent = 'Nội dung ca được máy chủ cung cấp qua public_bundle.';
  root.append(body);
  const form = document.createElement('form');
  form.dataset.caseForm = '';
  const input = document.createElement('textarea');
  input.name = 'answers';
  input.required = true;
  input.placeholder = 'Nhập quyết định của bạn';
  form.append(input);
  const submit = document.createElement('button');
  submit.type = 'submit';
  submit.textContent = 'Nộp quyết định';
  form.append(submit);
  form.addEventListener('submit', event => {
    event.preventDefault();
    onSubmit?.(input.value, form);
  });
  root.append(form);
}

export function renderResult(root, result) {
  const label = result?.review_label;
  const old = root.querySelector('[data-review-label]');
  if (old) old.remove();
  if (label != null) renderReviewLabel(root, result);
  const box = document.createElement('section');
  box.dataset.result = '';
  box.textContent = 'Kết quả và đáp án được hiển thị sau khi máy chủ xác nhận submission.';
  root.append(box);
}
