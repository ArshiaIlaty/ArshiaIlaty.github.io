/* Custom enhancements: dark-mode toggle, scroll reveal, image lightbox.
   Vanilla JS, no dependencies. The theme is applied by an inline snippet in
   <head> (before paint, to avoid a flash); this file wires up the toggle. */
(function () {
	'use strict';

	/* ---------- Dark mode toggle ---------- */
	function currentTheme() {
		return document.documentElement.getAttribute('data-theme') || 'light';
	}
	function applyTheme(theme) {
		document.documentElement.setAttribute('data-theme', theme);
		try { localStorage.setItem('theme', theme); } catch (e) {}
		var btn = document.querySelector('.theme-toggle');
		if (btn) {
			btn.setAttribute('aria-pressed', theme === 'dark' ? 'true' : 'false');
			btn.setAttribute('aria-label', theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode');
		}
	}
	var toggle = document.querySelector('.theme-toggle');
	if (toggle) {
		toggle.addEventListener('click', function () {
			applyTheme(currentTheme() === 'dark' ? 'light' : 'dark');
		});
		applyTheme(currentTheme());
	}

	/* ---------- Scroll reveal ---------- */
	var revealables = document.querySelectorAll('[data-reveal]');
	if (revealables.length) {
		if ('IntersectionObserver' in window) {
			var io = new IntersectionObserver(function (entries) {
				entries.forEach(function (entry) {
					if (entry.isIntersecting) {
						entry.target.classList.add('revealed');
						io.unobserve(entry.target);
					}
				});
			}, { threshold: 0.12, rootMargin: '0px 0px -8% 0px' });
			revealables.forEach(function (el) { io.observe(el); });
		} else {
			revealables.forEach(function (el) { el.classList.add('revealed'); });
		}
	}

	/* ---------- Lightbox ---------- */
	var selector = '.photo-grid img, .gallery img, .awards-gallery img, .startup-photo img, .work-photo img';
	var thumbs = document.querySelectorAll(selector);
	if (thumbs.length) {
		var box = document.createElement('div');
		box.className = 'lightbox';
		box.innerHTML = '<button class="lightbox-close" aria-label="Close">&times;</button><img alt="">';
		document.body.appendChild(box);
		var bigImg = box.querySelector('img');
		var closeBtn = box.querySelector('.lightbox-close');

		function open(src, alt) {
			bigImg.src = src;
			bigImg.alt = alt || '';
			box.classList.add('open');
			document.body.style.overflow = 'hidden';
		}
		function close() {
			box.classList.remove('open');
			document.body.style.overflow = '';
		}

		thumbs.forEach(function (img) {
			img.classList.add('zoomable');
			img.addEventListener('click', function () { open(img.currentSrc || img.src, img.alt); });
		});
		closeBtn.addEventListener('click', close);
		box.addEventListener('click', function (e) { if (e.target === box) close(); });
		document.addEventListener('keydown', function (e) { if (e.key === 'Escape') close(); });
	}
})();
