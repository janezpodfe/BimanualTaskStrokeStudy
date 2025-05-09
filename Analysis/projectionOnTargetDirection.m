function [proj_S_dir, perp_component, neg_dir] = projectionOnTargetDirection(S, dir)
  % Normalize the direction vector
  dir = dir ./ vecnorm(dir,2,2);
  norm = [-dir(:,2), dir(:,1)];

  % Project F onto dir
  proj_S_dir = dot(S', dir') .* dir';
  neg_dir = length(find(dot(S', dir') < 0))/size(S,1);

  % Calculate the perpendicular component (F - projection of F onto dir)
  perp_component = dot(S', norm') .* norm';

  proj_S_dir=mean(vecnorm(proj_S_dir));
  perp_component=mean(vecnorm(perp_component));
end
