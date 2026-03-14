#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
List temporal_filter_cpp(List id, List dist, NumericVector t, double eps_temporal) {
  int n = t.size();
  List res_id(n);
  List res_dist(n);

  for (int i=0; i<n; i++) {
    IntegerVector vct_ids = id[i];
    if (vct_ids.size() == 0) {
        res_id[i] = IntegerVector(0);
        res_dist[i] = NumericVector(0);
        continue;
    }
    NumericVector vct_dist = dist[i];

    double t_ref = t[i];
    int m = vct_ids.size();
    std::vector<int> keep_ids;
    std::vector<double> keep_dist;
    for (int j = 0; j < m; j++) {
      // Convert R id to c++ compatible one
      int idx = vct_ids[j] - 1;
      double temp_dist = std::abs(t_ref - t[idx]);

      if (temp_dist <= eps_temporal) {
        keep_ids.push_back(vct_ids[j]);
        keep_dist.push_back(vct_dist[j]);
      }
    }

    res_id[i] = wrap(keep_ids);
    res_dist[i] = wrap(keep_dist);
  }

  return List::create(
    Named("dist") = res_dist,
    Named("id")   = res_id
  );
}
