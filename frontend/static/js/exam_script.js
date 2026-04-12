/* exam_script.js
   Handles:
   - Enabling the submit button only when an answer is selected
   - Proof panel open/close toggle with animation
   - Intake form validation (presentation + demographics both required)
   - Keyboard shortcut: Y/N for yes-no questions, Enter to advance
*/

(function () {
  'use strict';

  /* ── Answer selection → enable submit ──────────────────────── */
  const answerForm = document.getElementById('answerForm');
  const nextBtn    = document.getElementById('nextBtn');
  const numberInput = document.getElementById('numberInput');

  if (answerForm && nextBtn) {
    // Radio inputs: enable on any selection
    answerForm.querySelectorAll('input[type="radio"]').forEach(function (radio) {
      radio.addEventListener('change', function () {
        nextBtn.disabled = false;
      });
    });

    // Number input: enable when value is present
    if (numberInput) {
      numberInput.addEventListener('input', function () {
        nextBtn.disabled = !numberInput.value;
      });
    }
  }

  /* ── Intake form: require both presentation and demographics ── */
  const intakeForm = document.getElementById('intakeForm');
  const startBtn   = document.getElementById('startBtn');

  if (intakeForm && startBtn) {
    function checkIntakeReady() {
      var hasPres = !!intakeForm.querySelector('input[name="presentation"]:checked');
      var hasAge  = !!intakeForm.querySelector('#age').value;
      var hasSex  = !!intakeForm.querySelector('input[name="sex"]:checked');
      startBtn.disabled = !(hasPres && hasAge && hasSex);
    }

    intakeForm.addEventListener('change', checkIntakeReady);
    intakeForm.querySelector('#age').addEventListener('input', checkIntakeReady);
  }

  /* ── Keyboard shortcuts on question pages ───────────────────── */
  if (answerForm) {
    var yesInput = answerForm.querySelector('input[value="yes"]');
    var noInput  = answerForm.querySelector('input[value="no"]');

    document.addEventListener('keydown', function (e) {
      if (e.target.tagName === 'INPUT' && e.target.type !== 'radio') return;
      if (e.metaKey || e.ctrlKey || e.altKey) return;

      if (e.key === 'y' || e.key === 'Y') {
        if (yesInput) { yesInput.checked = true; yesInput.dispatchEvent(new Event('change')); }
      }
      if (e.key === 'n' || e.key === 'N') {
        if (noInput) { noInput.checked = true; noInput.dispatchEvent(new Event('change')); }
      }
      if (e.key === 'Enter' && nextBtn && !nextBtn.disabled) {
        answerForm.submit();
      }
    });
  }

  /* ── Proof panel toggle ─────────────────────────────────────── */
  // Called from results.html onclick="toggleProof('dx-N')"
  window.toggleProof = function (cardId) {
    var card = document.getElementById(cardId);
    if (!card) return;
    card.classList.toggle('open');
  };

  /* ── Auto-open first non-excluded diagnosis on results page ─── */
  var firstCard = document.querySelector('.dx-card:not(.dx-excluded)');
  if (firstCard) {
    firstCard.classList.add('open');
  }

})();
