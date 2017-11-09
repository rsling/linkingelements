# -*- coding: utf-8 -*-

# Time taken to run on webcorpora.org (2017/11/7) approx. 15h.

import re, sys
from ManaCOW import cow_query, cow_raw_to_flat

OUTDIR      = '/home/schaefer/Projects/Fugen/Newsample/Output/'
CORPUS      = 'decow16a'
ATTRIBUTES  = ['word']
STRUCTURES  = []
REFERENCES  = ['doc.url', 'doc.id', 's.idx']
MAX_HITS    = -1

MATRIX_Q    = u'[compana="%s"&tag="NN"]within<s/>'

Queries = [
  u'Apfel(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Apfel_\+=_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Auge(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Auge_\+n_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Bad(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Bad_\+=er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Ball(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Ball_\+=e_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Bauer(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Bauer_\+n_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Bett(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Bett_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Bild(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Bild_\+er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Brett(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Brett_\+er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Brief(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Brief_\+e_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Buch(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Buch_\+=er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Bucht(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Bucht_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Dämon(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Dämon_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Ei(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Ei_\+er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Frau(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Frau_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Gerät(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Gerät_\+e_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Geschenk(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Geschenk_\+e_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Gitarre(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Gitarre_\+n_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Hand(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Hand_\+=e_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Haus(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Haus_\+=er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Hund(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Hund_\+e_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Hüfte(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Hüfte_\+n_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Instrument(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Instrument_\+e_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Katze(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Katze_\+n_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Kind(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Kind_\+er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Kunde(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Kunde_\+n_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Lied(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Lied_\+er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Mutter(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Mutter_\+=_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Nagel(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Nagel_\+=_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Ohr(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Ohr_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Person(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Person_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Portion(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Portion_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Produkt(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Produkt_\+e_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Rad(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Rad_\+=er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Schloss(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Schloss_\+=er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Schwert(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Schwert_\+er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Sonne(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Sonne_\+n_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Stadt(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Stadt_\+=e_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Universität(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Universität_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Vater(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Vater_\+=_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Vogel(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Vogel_\+=_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Weg(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Weg_\+e_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Wurm(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Wurm_\+=er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Zahn(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Zahn_\+=e_[A-ZÄÖÜ][a-zäöüßéè]+$',

  u'Kommune(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Kommune_\+n_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Horde(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Horde_\+n_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Definition(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Definition_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Mehrheit(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Mehrheit_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Projektor(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Projektor_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',

  u'Birne(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Birne_\+n_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Schwester(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Schwester_\+n_[A-ZÄÖÜ][a-zäöüßéè]+$',

  u'Hemd(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Hemd_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Nation(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Nation_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Eigenschaft(_\(e\)_\+s_|_\+s_|_|_-e_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Eigenschaft_\+en_[A-ZÄÖÜ][a-zäöüßéè]+$',

  u'Element(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Element_\+e_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Geräusch(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Geräusch_\+e_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Zitat(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Zitat_\+e_[A-ZÄÖÜ][a-zäöüßéè]+$',

  u'Loch(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Loch_\+=er_[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Strauch(_\(e\)_\+s_|_\+s_|_)[A-ZÄÖÜ][a-zäöüßéè]+$',
  u'Strauch_\+=er_[A-ZÄÖÜ][a-zäöüßéè]+$'
]


def cow_print_query(query, file = None, matchmark_left = '', matchmark_right = '',
  match_dedup = True, annotate_match_dups = False):
  attrs_flag = True if len(query['attributes']) > 1 else False
  conc = cow_raw_to_flat(query['concordance'], attrs_flag)

  handle = open(file, 'w') if file is not None else sys.stdout

  # Write header.
  handle.write('# = BASIC =============================================================\n')
  handle.write('# QUERY:         %s\n' % query['query'])
  handle.write('# CORPUS:        %s\n' % query['corpus'])
  handle.write('# HITS:          %s\n' % query['hits'])
  handle.write('# DATETIME:      %s\n' % query['datetime'])
  handle.write('# ELAPSED:       %s s\n' % str(query['elapsed']))
  handle.write('# = CONFIG ============================================================\n')
  handle.write('# MAX_HITS:      %s\n' % query['max_hits'])
  handle.write('# RANDOM_SUBSET: %s\n' % query['random_subset'])
  handle.write('# ATTRIBUTES:    %s\n' % ','.join(query['attributes']))
  handle.write('# STRUCTURES:    %s\n' % ','.join(query['structures']))
  handle.write('# REFERENCES:    %s\n' % ','.join(query['references']))
  handle.write('# CONTAINER:     %s\n' % query['container'])
  handle.write('# CNT_LEFT:      %s\n' % query['context_left'])
  handle.write('# CNT_RIGHT:     %s\n' % query['context_right'])
  handle.write('# DEDUPING:      %s\n' % query['deduping'])
  handle.write('# DUPLICATES:    %s\n' % query['duplicates'])
  handle.write('# = CONCORDANCE TSV ===================================================\n')

  rex = re.compile('^<.+>$')

  uniques  = set()
  deduped_matches = 0
  is_dup   = "\t1"
  not_dup  = "\t0"
  dup_here = False


  # Write concordance.
  if int(query['hits']) > 1:
    if match_dedup and annotate_match_dups:
      handle.write('\t'.join(query['references'] + ['left.context', 'match', 'right.context', 'dup.match']) + '\n')
    else:
      handle.write('\t'.join(query['references'] + ['left.context', 'match', 'right.context']) + '\n')

    for l in conc:

      # Find true tokens via indices (not structs) for separating match from context.
      indices      = [i for i, s in enumerate(l['line']) if not rex.match(s[0])]
      match_start  = indices[l['match_offset']]
      match_end    = indices[l['match_offset'] + l['match_length'] - 1]
      match_length = match_end - match_start + 1

      # The uniqueness check.
      if match_dedup:
        matsch = ''.join([''.join(token) for token in l['line'][match_start:match_end+1]])
        if matsch in uniques:
          deduped_matches = deduped_matches + 1
          if annotate_match_dups:
            dup_here = True
          else:
            continue
        else:
          dup_here = False
          uniques.add(matsch)

      # Write meta, left, match, right.
      handle.write('\t'.join(l['meta']) + '\t')
      handle.write(' '.join(['|'.join(token) for token in l['line'][:match_start]]) + '\t' + matchmark_right)
      handle.write(' '.join(['|'.join(token) for token in l['line'][match_start:match_end+1]]) + matchmark_left + '\t')
      handle.write(' '.join(['|'.join(token) for token in l['line'][match_end+1:]]))
      if annotate_match_dups:
        if dup_here:
          handle.write(is_dup)
        else:
          handle.write(not_dup)
      handle.write('\n')

  if match_dedup:
    handle.write('# = FINAL COMMENTS ===================================================\n')
    handle.write('# MATCH DUPS:    %d\n' % deduped_matches)

  if handle is not sys.stdout:
      handle.close()


for Q in Queries:
  fname = OUTDIR + re.sub(r'^([^_()]+).+$', r'\1', Q, re.UNICODE)
  if re.search(r'\|', Q):
    fname = fname + '0.csv'
  else:
   fname = fname + '1.csv'

  realq = MATRIX_Q % Q

  print fname.encode('utf-8')
  query = cow_query(realq.encode('utf-8'), corpus = CORPUS, references = REFERENCES,
    attributes = ATTRIBUTES, structures = STRUCTURES, deduping = False,
    max_hits = MAX_HITS,
    context_left = 1, context_right = 1)

  cow_print_query(query, file = fname, annotate_match_dups = True)
