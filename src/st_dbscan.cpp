#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
IntegerVector st_dbscan_cpp(NumericVector x,
                            NumericVector y,
                            NumericVector t,
                            double eps_spatial,
                            double eps_temporal,
                            int min_pts) {

  int n = x.size();
  IntegerVector labels(n, 0); // 0 = unvisited, -1 = noise
  int cluster_id = 0;

  for (int i = 0; i < n; i++) {

    if (labels[i] != 0)
      continue;

    // Find neighbors
    std::vector<int> neighbors;
    for (int j = 0; j < n; j++) {
      double dx = x[i] - x[j];
      double dy = y[i] - y[j];
      double dist_spatial = std::sqrt(dx*dx + dy*dy);
      double dist_temporal = std::abs(t[i] - t[j]);

      if (dist_spatial <= eps_spatial &&
          dist_temporal <= eps_temporal) {
        neighbors.push_back(j);
      }
    }

    if ((int)neighbors.size() < min_pts) {
      labels[i] = -1;
      continue;
    }

    // Start new cluster
    cluster_id++;
    labels[i] = cluster_id;

    // Expand cluster
    for (size_t k = 0; k < neighbors.size(); k++) {
      int p = neighbors[k];

      if (labels[p] == -1)
        labels[p] = cluster_id;

      if (labels[p] != 0)
        continue;

      labels[p] = cluster_id;

      // Find neighbors of p
      std::vector<int> neighbors_p;
      for (int j = 0; j < n; j++) {
        double dx = x[p] - x[j];
        double dy = y[p] - y[j];
        double dist_spatial = std::sqrt(dx*dx + dy*dy);
        double dist_temporal = std::abs(t[p] - t[j]);

        if (dist_spatial <= eps_spatial &&
            dist_temporal <= eps_temporal) {
          neighbors_p.push_back(j);
        }
      }

      if ((int)neighbors_p.size() >= min_pts) {
        neighbors.insert(neighbors.end(),
                         neighbors_p.begin(),
                         neighbors_p.end());
      }
    }
  }

  return labels;
}
