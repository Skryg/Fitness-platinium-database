import { CanActivateFn } from '@angular/router';
import { Router } from '@angular/router';
import { inject } from '@angular/core';
import { PermissionService } from './service/permission.service';
export const authenticationGuard: CanActivateFn = (route, state) => {
  const permissionService = inject(PermissionService);
  permissionService.proceed();
  if(state.url == "/login"){
    return true;
  }
  const router = inject(Router);
  // alert("dupa");
  let token = sessionStorage.getItem('token');
  
  if(!token){
    // alert("slonia");
    return router.parseUrl("/login");
  }

  return true;
};

