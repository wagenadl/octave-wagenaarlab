// matchupx_core.cpp

/*
mkoctfile -std=c++11 matchupx_core.cpp 
*/

#include <octave/oct.h>
#include <vector>
#include <set>
#include <algorithm>

constexpr int K = 3; // max number of candidates

struct Coord {
  double x;
  double y;
  double r;
};

struct Cand {
  int idx;
  double merit;
  inline bool operator<(Cand const &c) {
    // Cand A<B if it has *higher* merit.
    return merit>c.merit;
  }
};

struct OrderedCanon {
  int idx;
  double r;
  inline bool operator<(OrderedCanon const &c) {
    // OrderedCanon A<B if A has a larger radius
    return r>c.r;
  }
};

inline double merit(Coord const &act, Coord const &can, double scl) {
  double dx = act.x - can.x;
  double dy = act.y - can.y;
  double dr = act.r - can.r;
  double dd = dx*dx + dy*dy + dr*dr;
  return exp(scl * dd);
}

int level = 0;

std::vector<int> bestchoices(std::vector<int> &can2choice,
                             std::vector<int> &act2can,
                             std::vector<double> &merits,
                             std::vector< std::vector<Cand> > const &cands,
                             std::set<int> &untouchables,
                             int m, double &merit_out) {
  /* We are being asked to (re)assign canonical m. There may be a
     pre-existing choice in can2choice[m], or not (can2choice[m]<0). We
     should evacuate that pre-existing choice and try something else.
     That may cause a shift elsewhere. We return the whole chain of new
     choices.
  */
  double lostmerit = merits[m];
  //  printf("%2i bestchoices %i (%g)\n", level, m, lostmerit);
  level ++;
  std::vector<int> bestchoice;
  double bestmerit = 0;
  for (int choice = can2choice[m] + 1; choice<K; choice++) {
    int n = cands[m][choice].idx;
    double merit = cands[m][choice].merit;
    int m_victim = act2can[n];
    // printf("  considering %i:%i: %i:%i (%g)\n", m, choice, n, m_victim, merit);
    if (m_victim<0) {
      // easy, we can have this choice without bothering anyone
      if (merit>=bestmerit) {
        merit_out = merit - lostmerit;
        bestchoice.clear();
        bestchoice.push_back(choice);
        level --;
        // printf("  ->");
        // for (auto &i: bestchoice)
        //   printf(" %i", i);
        // printf("\n");
        return bestchoice;
      }
    } else if (untouchables.find(m_victim)==untouchables.end()) {
      // not so easy, but let's see...
      double submerit;
      untouchables.insert(m);
      std::vector<int> subchoices = bestchoices(can2choice, act2can,
                                                merits, cands,
                                                untouchables,
                                                m_victim, submerit);
      untouchables.erase(m);
      if (merit + submerit >= bestmerit) {
        bestchoice.clear();
        bestchoice.push_back(choice);
        bestchoice.insert(bestchoice.end(),
                          subchoices.begin(), subchoices.end());
        bestmerit = merit + submerit;
      }
    } else {
      // loop detected; don't do it
    }
  }
  merit_out = bestmerit - lostmerit;
  level --;
  // printf("  ->");
  // for (auto &i: bestchoice)
  //  printf(" %i", i);
  // printf("\n");
  return bestchoice;
}  

void assign(std::vector<int> &can2choice,
	    std::vector<int> &act2can,
	    std::vector<double> &merits,
	    std::vector< std::vector<Cand> > const &cands,
	    int m) {
  /* Does the best job assigning an actual to ordered canonical m_, possibly
     displacing earlier assignments.
  */
  double dummy;
  std::set<int> untouch;
  // printf("\n");
  std::vector<int> choices{bestchoices(can2choice, act2can, merits, cands,
                                       untouch, m, dummy)};
  if (choices.empty()) {
    // printf("error: no choices\n");
    can2choice[m] = -1;
    merits[m] = 0;
    return;
  }
  for (int k=0; k<choices.size(); k++) {
    can2choice[m] = choices[k];
    merits[m] = cands[m][choices[k]].merit;
    int n = cands[m][choices[k]].idx;
    int m_orig = act2can[n];
    act2can[n] = m;
    m = m_orig;
  }
}

DEFUN_DLD(matchupx_core, args, /*nargout*/,
          "Match up actual and canonical map") {
  NDArray act_ar = args(0).array_value();
  NDArray can_ar = args(1).array_value();
  NDArray S_ar = args(2).array_value();

  int N = act_ar.numel()/3;
  int M = can_ar.numel()/3;
  double S = S_ar(0);

  Coord const *act = reinterpret_cast<Coord const *>(act_ar.fortran_vec());
  Coord const *can = reinterpret_cast<Coord const *>(can_ar.fortran_vec());

  //  printf("NM=%i %i\n", N, M);
  
  std::vector< std::vector<Cand> > cands(M);
  for (int m=0; m<M; m++) {
    std::vector<Cand> v(N);
    for (int n=0; n<N; n++) 
      v[n] = Cand{n, merit(act[n], can[m], -0.5*S*S)};
    std::partial_sort(v.begin(), v.begin() + K, v.end());
    v.resize(K);
    cands[m] = v;
  }
  // So cands[m] now lists the best K candidate actuals to match to
  // canonical #m in order of decreasing merit.

  //  printf("sorted\n");
  
  std::vector< OrderedCanon> canOrder(M);
  for (int m=0; m<M; m++)
    canOrder[m] = OrderedCanon{m, can[m].r};
  std::sort(canOrder.begin(), canOrder.end());
  // So canOrder now lists canonicals in order of decreasing radius.

  //  printf("ordered\n");
  
  std::vector<int> can2choice(M, -1);
  std::vector<double> merits(M);
  std::vector<int> act2can(N, -1);

  for (int m_=0; m_<M; m_++) 
    assign(can2choice, act2can, merits, cands, canOrder[m_].idx);

  //  printf("assigned\n");
  
  dim_vector dv(M,1);
  int32NDArray can2act_ar(dv);
  NDArray merits_ar(dv);
  for (int m=0; m<M; m++) {
    int choice = can2choice[m];
    if (choice>=0 && choice<K) {
      can2act_ar(m) = cands[m][choice].idx;
      merits_ar(m) = merits[m];
    } else {
      can2act_ar(m) = -1;
      merits_ar(m) = 0;
    }
  }
  //  printf("done\n");
  octave_value_list res(2);
  res(0) = octave_value(can2act_ar);
  res(1) = octave_value(merits_ar);
  return res;
}

  

  
