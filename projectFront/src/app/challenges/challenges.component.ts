import { Component } from '@angular/core';
import { ClientService } from '../service/client.service';

@Component({
  selector: 'app-challenges',
  templateUrl: './challenges.component.html',
  styleUrls: ['./challenges.component.css']
})
export class ChallengesComponent {

  from: Array<string> = [];
  to: Array<string> = [];
  minEntries: Array<string> = [];
  rewards: Array<string> = [];
  idAward: number = 0;

  constructor(private clientService: ClientService) { }

  ngOnInit(): void {
    this.clientService.getChallenges().subscribe((data: any) => {
      console.log(data);
      let cnt = 0;
      let tmp = "";
      for (let i = 0; i < data.toString().length; i++) {
        if (data.toString()[i] == ',') {
          if (cnt == 0) {
            this.from.push(tmp);
          } else if (cnt == 1) {
            this.to.push(tmp);
          } else if (cnt == 2) {
            this.minEntries.push(tmp);
          } else if (cnt == 3) {
            this.rewards.push(tmp);
            cnt = -1;
        }
        cnt++;
        tmp = "";
      }
      else
        tmp+=data.toString()[i];
      }
      console.log(tmp);
      this.rewards.push(tmp);
    });

  }

  message: string = '';
  giveAwards() {
    this.clientService.giveAwards(this.idAward).subscribe(data => {
      console.log(data);
      this.message = data.toString();
    }, error => console.log(error));
  }

}
