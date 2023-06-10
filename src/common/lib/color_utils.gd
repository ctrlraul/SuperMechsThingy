class_name ColorUtils


static func from_hsl(h: float, s: float, l: float, a: float) -> Color:
	if s:

		if h == 1.0:
			h = 0.0

		var i = int(h * 6.0);
		var f = h * 6.0 - i

		var w = l * (1.0 - s)
		var q = l * (1.0 - s * f)
		var t = l * (1.0 - s * (1.0 - f))

		if i == 0: return Color(l, t, w, a)
		if i == 1: return Color(q, l, w, a)
		if i == 2: return Color(w, l, t, a)
		if i == 3: return Color(w, q, l, a)
		if i == 4: return Color(t, w, l, a)
		if i == 5: return Color(l, w, q, a)

	else:
		return Color(l, l, l, a)

	return Color(0, 0, 0, a)
