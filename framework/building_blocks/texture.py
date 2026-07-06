"""Phrase-aware texture generators (revision pass 1).
Rule: no audible block repeats unvaried beyond ~4 bars."""
from ..foundation.score import R


def _oct(p, n=1):
    return p[:-1] + str(int(p[-1]) + n)


def psy_seq(bar_roots, up_map, down_map, start=0):
    """Goa bass over per-bar roots. 4-bar phrasing:
    bar%4==2 -> c-variation (beat 3 climbs to neighbor above),
    bar%4==3 -> d-variation (beat 2 dips below); octave pop each 8th bar.
    K-bbb K-bbb K-bcc K-bdb ... reinforcing the harmonic line."""
    out = []
    for i, root in enumerate(bar_roots, start):
        letter, octv = root[:-1], root[-1]
        up = up_map[letter] + octv
        dn = down_map[letter] + octv
        m = i % 4
        for b in range(4):
            if m == 2 and b == 2:
                out += [R(0.25), (root, 0.25), (up, 0.25), (up, 0.25)]
            elif m == 3 and b == 1:
                out += [R(0.25), (root, 0.25), (dn, 0.25), (root, 0.25)]
            elif i % 8 == 7 and b == 3:
                out += [R(0.25), (root, 0.25), (_oct(root), 0.25), (root, 0.25)]
            else:
                out += [R(0.25), (root, 0.25), (root, 0.25), (root, 0.25)]
    return out


def contour_trem(p, nbars, up, dn, octn=1, start=0):
    """Tremolo 16ths with phrase contour: plain / neighbor-bite / plain / octave-alternation."""
    out = []
    for i in range(start, start + nbars):
        m = i % 4
        if m == 1:
            out += [(p, 0.25)] * 12 + [(up, 0.25), (p, 0.25), (dn, 0.25), (p, 0.25)]
        elif m == 3:
            out += [(p, 0.25), (_oct(p, octn), 0.25)] * 8
        else:
            out += [(p, 0.25)] * 16
    return out


def breathe(p, nbars, neighbor=None, dyn=None):
    """Sustained line that re-attacks and breathes: (p,3)(p,1) per bar,
    with a neighbor turn every 4th bar."""
    out = []
    for i in range(nbars):
        d = [dyn] if (dyn and i == 0) else []
        if neighbor and i % 4 == 3:
            out += [tuple([p, 2] + d), (neighbor, 1), (p, 1)]
        else:
            out += [tuple([p, 3] + d), (p, 1)]
    return out
