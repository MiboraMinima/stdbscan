#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
List temporal_filter_pred_cpp(List id, NumericVector n_t, NumericVector t, double eps_temporal) {
  int n = id.size();
  List res_id(n);

  for (int i=0; i<n; i++) {
    IntegerVector vct_ids = id[i];
    if (vct_ids.size() == 0) {
        res_id[i] = IntegerVector(0);
        continue;
    }

    double t_ref = n_t[i];
    int m = vct_ids.size();
    std::vector<int> keep_ids;
    for (int j = 0; j < m; j++) {
      // Convert R id to c++ compatible one
      int idx = vct_ids[j] - 1;
      double temp_dist = std::abs(t_ref - t[idx]);

      if (temp_dist <= eps_temporal) {
        keep_ids.push_back(vct_ids[j]);
      }
    }

    res_id[i] = wrap(keep_ids);
  }

  return res_id;
}

